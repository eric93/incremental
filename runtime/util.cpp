#include "util.h"
#include <cstdio>
#include <cstdlib>

int max(int a, int b) {
    return a > b ? a : b;
}

const char* to_string(int x) {
    return "Unimplemented";
}


InputLength new_input_length(InputType t, InputValue v){
    InputLength i = {t,v};
    return i;
}

bool is_auto(InputLength l) {
    if (l.type == AUTO) {
        return true;
    }
    return false;
}

int spec_or_zero(InputLength l, int available_width) {
    switch (l.type) {
        case AUTO:
            return 0;
        case PERCENT:
            return l.value.float_val * available_width;
        case FIXED:
            return l.value.integer_val;
    }
}

int specified(InputLength l, int available_width) {
    switch (l.type) {
        case AUTO:
            ASSERT(false,"Error");
        case PERCENT:
            return l.value.float_val * available_width;
        case FIXED:
            return l.value.integer_val;
    }
}

const char* to_string(InputLength x) {
    return "Unimplemented";
}

DisplayList new_display_list() {
    DisplayList lst;
    lst.list = NULL;
    return lst;
}

DisplayList add_background(DisplayList old_list, int x,int y ,int width, int height){
    return old_list;
}
DisplayList add_border(DisplayList old_list, int x, int y, int width, int height, int bt, int br, int bb, int bl){
    return old_list;
}
DisplayList add_text_fragment(DisplayList old_list, int x, int y, int width, int height){
    return old_list;
}

DisplayList merge_lists(DisplayList list1, DisplayList list2) {
    return list1;
}

const char* to_string(DisplayList x) {
    return "Unimplemented";
}


Tree::Tree(Tree* c, unsigned int num_c, Tree* p, int n) {
    children = c;
    num_children = num_c;
    parent = p;
    num = n;
}

Attributes new_blockflow_attrs(BlockFlow* flow){
    Attributes a = {BLOCK_FLOW, flow};
    return a;
}
Attributes new_inlineflow_attrs(InlineFlow* flow){
    Attributes a = {INLINE_FLOW, flow};
    return a;
}
Attributes new_inlinebox_attrs(InlineBox* box){
    Attributes a = {INLINE_BOX, box};
    return a;
}


