interface Top {
    input a : int;
    input a_delta : bool;
}

interface HVBox {
    var width : int;
    var width_delta_0 : bool;
    var width_delta : bool;
    input width_old : int;
    input width_old_0 : int;
    var height : int;
    var height_delta_0 : bool;
    var height_delta : bool;
    input height_old : int;
    input height_old_0 : int;
    var right : int;
    var right_delta_0 : bool;
    var right_delta : bool;
    input right_old : int;
    input right_old_0 : int;
    var bottom : int;
    var bottom_delta_0 : bool;
    var bottom_delta : bool;
    input bottom_old : int;
    input bottom_old_0 : int;
    input visible : bool;
    input visible_delta : bool;
}

class Root : Top {
    children {
        root : HVBox;

    }
    attributes {

    }
    actions {
        root.right_delta_0 := root.width_delta ;

        root.right := (root.right_delta_0) ? (root.width) : (root.right_old_0) ;

        root.right_delta := (root$i.right) != (root$i.right_old_0) ;

        root.bottom_delta_0 := root.height_delta ;

        root.bottom := (root.bottom_delta_0) ? (root.height) : (root.bottom_old_0) ;

        root.bottom_delta := (root$i.bottom) != (root$i.bottom_old_0) ;

    }

}

class HBox : HVBox {
    children {
        childs : [HVBox];

    }
    attributes {
    var childsWidth : int;
    var childsWidth_delta_0 : bool;
    var childsWidth_delta : bool;
    input childsWidth_old : int;
    input childsWidth_old_0 : int;
    var childsHeight : int;
    var childsHeight_delta_0 : bool;
    var childsHeight_delta : bool;
    input childsHeight_old : int;
    input childsHeight_old_0 : int;
    }
    actions {
        loop childs {
            childsWidth_delta_0 := fold (false) .. (($-.childsWidth_delta_0) || (childs$i.width_delta)) ;

            childsWidth := fold ((childsWidth_delta_0) ? (0) : (childsWidth_old)) .. ((childsWidth_delta_0) ? (($-.childsWidth) + (childs$i.width)) : ($-.childsWidth)) ;

            childsHeight_delta_0 := fold (false) .. (($-.childsHeight_delta_0) || ((childs$i.height_delta) || (childs$i.height_delta))) ;

            childsHeight := fold ((childsHeight_delta_0) ? (0) : (childsHeight_old)) .. ((childsHeight_delta_0) ? ((($-.childsHeight) > (childs$i.height)) ? ($-.childsHeight) : (childs$i.height)) : ($-.childsHeight)) ;

            childs.right_delta_0 := fold (right_delta) .. ((childs$-.right_delta) || (childs$i.width_delta)) ;

            childs.right := fold (right) .. ((childs$i.right_delta_0) ? ((childs$-.right) + (childs$i.width)) : (childs$i.right_old_0)) ;

            childs.right_delta := fold (0) .. ((childs$i.right) != (childs$i.right_old_0)) ;

            childs.bottom_delta_0 := bottom_delta ;

            childs.bottom := (childs.bottom_delta_0) ? (bottom) : (childs.bottom_old_0) ;

            childs.bottom_delta := (childs$i.bottom) != (childs$i.bottom_old_0) ;
        }

        childsWidth_delta := (childsWidth) != (childsWidth_old_0) ;

        childsHeight_delta := (childsHeight) != (childsHeight_old_0) ;

        width_delta_0 := (visible_delta) || (childsWidth_delta) ;

        width := (width_delta_0) ? ((visible) ? (childsWidth) : (0)) : (width_old_0) ;

        width_delta := (width) != (width_old_0) ;

        height_delta_0 := (visible_delta) || (childsHeight_delta) ;

        height := (height_delta_0) ? ((visible) ? (childsHeight) : (0)) : (height_old_0) ;

        height_delta := (height) != (height_old_0) ;

    }

}

class VBox : HVBox {
    children {
        childs : [HVBox];

    }
    attributes {
    var childsWidth : int;
    var childsWidth_delta_0 : bool;
    var childsWidth_delta : bool;
    input childsWidth_old : int;
    input childsWidth_old_0 : int;
    var childsHeight : int;
    var childsHeight_delta_0 : bool;
    var childsHeight_delta : bool;
    input childsHeight_old : int;
    input childsHeight_old_0 : int;
    }
    actions {
        loop childs {
            childsWidth_delta_0 := fold (false) .. (($-.childsWidth_delta_0) || ((childs$i.width_delta) || (childs$i.width_delta))) ;

            childsWidth := fold ((childsWidth_delta_0) ? (0) : (childsWidth_old)) .. ((childsWidth_delta_0) ? ((($-.childsWidth) > (childs$i.width)) ? ($-.childsWidth) : (childs$i.width)) : ($-.childsWidth)) ;

            childsHeight_delta_0 := fold (false) .. (($-.childsHeight_delta_0) || (childs$i.height_delta)) ;

            childsHeight := fold ((childsHeight_delta_0) ? (0) : (childsHeight_old)) .. ((childsHeight_delta_0) ? (($-.childsHeight) + (childs$i.height)) : ($-.childsHeight)) ;

            childs.bottom_delta_0 := fold (bottom_delta) .. ((childs$-.bottom_delta) || (childs$i.height_delta)) ;

            childs.bottom := fold (bottom) .. ((childs$i.bottom_delta_0) ? ((childs$-.bottom) + (childs$i.height)) : (childs$i.bottom_old_0)) ;

            childs.bottom_delta := fold (0) .. ((childs$i.bottom) != (childs$i.bottom_old_0)) ;

            childs.right_delta_0 := right_delta ;

            childs.right := (childs.right_delta_0) ? (right) : (childs.right_old_0) ;

            childs.right_delta := (childs$i.right) != (childs$i.right_old_0) ;
        }

        childsWidth_delta := (childsWidth) != (childsWidth_old_0) ;

        childsHeight_delta := (childsHeight) != (childsHeight_old_0) ;

        width_delta_0 := (visible_delta) || (childsWidth_delta) ;

        width := (width_delta_0) ? ((visible) ? (childsWidth) : (0)) : (width_old_0) ;

        width_delta := (width) != (width_old_0) ;

        height_delta_0 := (visible_delta) || (childsHeight_delta) ;

        height := (height_delta_0) ? ((visible) ? (childsHeight) : (0)) : (height_old_0) ;

        height_delta := (height) != (height_old_0) ;

    }

}

class Leaf : HVBox {
    children {

    }
    attributes {
    input width_in : int;
    input width_in_delta : bool;
    input height_in : int;
    input height_in_delta : bool;
    }
    actions {
        width_delta_0 := width_in_delta ;

        width := (width_delta_0) ? (width_in) : (width_old_0) ;

        width_delta := (width) != (width_old_0) ;

        height_delta_0 := height_in_delta ;

        height := (height_delta_0) ? (height_in) : (height_old_0) ;

        height_delta := (height) != (height_old_0) ;

    }

}
