#ifndef __UTIL_H__
#define __UTIL_H__
#define ASSERT(x,y) if (!(x)) { printf(y); exit(-1); }

struct BlockFlow;
struct InlineFlow;
struct InlineBox;

int max(int, int);
const char* to_string(int);

enum InputType {
    AUTO,
    PERCENT,
    FIXED
};

union InputValue {
    int integer_val;
    float float_val;
};

struct InputLength {
    InputType type;
    InputValue value;
};

InputLength new_input_length(InputType,InputValue);
bool is_auto (InputLength l);
int spec_or_zero (InputLength l, int available_width);
int specified (InputLength l, int available_width);
const char* to_string(InputLength);

struct DisplayList {
    int* list;
};

DisplayList new_display_list();
DisplayList add_background(DisplayList,int,int,int,int);
DisplayList add_border(DisplayList,int,int,int,int,int,int,int,int);
DisplayList add_text_fragment(DisplayList,int,int,int,int);
DisplayList merge_lists(DisplayList, DisplayList);
const char* to_string(DisplayList);

enum NodeType {
    BLOCK_FLOW,
    INLINE_FLOW,
    INLINE_BOX
};

struct Attributes {
    NodeType type;
    void* attr_struct;
};

Attributes new_blockflow_attrs(BlockFlow*);
Attributes new_inlineflow_attrs(InlineFlow*);
Attributes new_inlinebox_attrs(InlineBox*);


enum TravType{
    TOP_DOWN,
    BOTTOM_UP
};


struct Tree {
    Tree* children;
    Tree* parent;
    unsigned int num_children;
    unsigned int children_visited;
    int num;
    Attributes attributes;

    Tree(Tree* c, unsigned int num_c, Tree* p, int n);
};

struct Traversal {
    TravType type;
    void (*visit)(Tree*);
};

#endif
