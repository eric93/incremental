# Incremental attribute grammar evlauation

## Tracking dynamic changes

This is what Reps et al. do in their dynamic interpreter for AGs. However, to
get the parallelism benefits, it makes more sense for us to phrase this as a
translation between AGs and schedule the translated AG. For example, consider
the HBox grammar:

```
interface Node {
  attr height;
  attr ypos;
}

class Root : Node {
  child : Node;
  actions {
    height := child.height;
    child.ypos := 0;
  }
}

class VBox : Node {
  child ch1 : Node;
  child ch2 : Node;

  actions { 
    height := ch1.height + ch2.height;
    ch1.ypos := ypos;
    ch2.ypos := ch1.ypos + ch1.height;
  }
}

class Leaf : Node {
  attriutes {
    input intrinsic_height;
  }
  actions {
    height := intrinsic_height;
  }
}
```

To translate this to its incremental version, we add `old` values as inputs and
guard all of the computations.

```
interface Node {
  attr height;
  attr ypos;

  input old_height;
  input old_ypos;
}

class Root : Node {
  child : Node;
  actions {
    if (child.height != child.old_height) {
      height := child.height;
    } else {
      height := old_height;
    }
  
    child.ypos := child.old_ypos;
  }
}

class VBox : Node {
  child ch1 : Node;
  child ch2 : Node;

  actions { 
    if (ch1.height != ch1.old_height || ch2.height != ch2.old_height) {
      height := ch1.height + ch2.height;
    } else {
      height := old_height;
    }

    if (ypos != old_ypos) {
      ch1.ypos := ypos;
    } else  {
      ch1.ypos := ch1.old_ypos;
    }

    if (ch1.ypos != ch1.old_ypos || ch1.height != ch1.old_height) {
      ch2.ypos := ch1.ypos + ch1.height;
    } else {
      ch2.ypos := ch2.old_ypos;
    }
  }
}

class Leaf : Node {
  attriutes {
    input intrinsic_height;
    input old_intrinsic_height;
  }
  actions {
    if (intrinsic_height != old_intrinsic_height) {
      height := intrinsic_height;
    } else {
      height := old_height;
    }
  }
}
```

## Dirty Bits

The dynamic change tracker is optimal in the sense that it performs the minimum
number of attribute updates. However, it may not be optimal in practice if it
introduces too much overhead. For example consider a grammar that outputs a
string encoding the structure of the tree:

```
interface Node {
  attr str;
}

class MidNode : Node {
  child ch1 : Node;
  child ch2 : Node;

  actions {
    str := "MidNode(" + ch1.str + ", " + ch2.str + ")";
  }
}

class Leaf : Node {
  attributes {
    input val;
  }
  actions {
    str := "Leaf(" + val.tostring() + ")";
  }
}
```

If we were to naively incrementalize this grammar, we would wind up performing
a string comparison at each node, which could be quite costly depending on the
depth of the tree. A better way to do this is to compare only the leaf values,
and then propagate a dirty bit up the tree to determine how much of the tree to
recompute:

```
interface Node {
  attr str;
  input old_str;
  attr str_d;
}

class MidNode : Node {
  child ch1 : Node;
  child ch2 : Node;

  actions {
    str_d := ch1.str_d || ch2.str_d;
  
    if (str_d) {
      str := "MidNode(" + ch1.str + ", " + ch2.str + ")";
    } else {
      str := old_str;
    }

  }
}

class Leaf : Node {
  attributes {
    input val;
    input old_val;
  }
  actions {
    if (val != old_val) {
      str := "Leaf(" + val.tostring() + ")";
      str_d := true;
    } else {
      str := old_str;
      str_d := false;
    }
  }
}
```

For any given computation in the orignal tree, there are multiple ways to
compute the dirty bit to varying levels of precision. We will also likely want
to trade off computing dirty bits with dynamic change tracking.

## Research Challenges

* How do we formalize incremental attribute grammars in such a way that incorporates dirty bits and dynamic change tracking?
  * Previous write-up was an attempt at this, but will likely need to be revised
* How do we implementa an efficient compiler for incremental attribute grammars?
  * Need to take advantage or parallelism.
  * Need to avoid recomputation and copying memory as much as possible.
