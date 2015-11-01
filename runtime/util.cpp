#include "util.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>

int max(int a, int b) {
    return a > b ? a : b;
}

const char* to_string(int x) {
    //FIXME: need to free this
    char* res = (char *) (malloc(10 * sizeof(char)));
    sprintf(res,"%d",x);
    return res;
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

InputLength rand_inp_length_auto() {
    unsigned int rint = rand() % 3;
    InputType t;
    if (rint == 0)
        t = AUTO;
    else if (rint == 1)
        t = PERCENT;
    else if (rint == 2)
        t = FIXED;
    else
        ASSERT(false, "Random number generation failed.");

    float rfloat = ((float) (rand())) / ((float) (RAND_MAX));
    int rint2 = rand() % 200;

    InputValue v;

    if (t == PERCENT) {
        v.float_val = rfloat;
    } else if (t == FIXED) {
        v.integer_val = rint2;
    }

    InputLength ret = {t,v};
    return ret;

}

InputLength rand_inp_length() {
    unsigned int rint = rand() % 3;
    InputType t;
    if (rint == 0)
        t = FIXED;
    else if (rint == 1)
        t = PERCENT;
    else if (rint == 2)
        t = FIXED;
    else
        ASSERT(false, "Random number generation failed.");

    float rfloat = ((float) (rand())) / ((float) (RAND_MAX));
    int rint2 = rand() % 200;

    InputValue v;

    if (t == PERCENT) {
        v.float_val = rfloat;
    } else if (t == FIXED) {
        v.integer_val = rint2;
    }

    InputLength ret = {t,v};
    return ret;

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
            ASSERT(false,"Error\n");
        case PERCENT:
            return l.value.float_val * available_width;
        case FIXED:
            return l.value.integer_val;
    }
}

const char* to_string(InputLength x) {
    //FIXME: need to free this
    char* res = (char *) (malloc(20 * sizeof(char)));
    switch (x.type) {
        case AUTO:
            strncpy(res, "Auto", 5);
            break;
        case PERCENT:
            sprintf(res, "%f%%",x.value.float_val * 100);
            break;
        case FIXED:
            sprintf(res, "%d", x.value.integer_val);
            break;
    }

    return res;
}

DisplayList new_display_list() {
    DisplayList lst;
    lst.first = NULL;
    lst.len = 0;
    return lst;
}

DisplayList add_background(DisplayList old_list, int x,int y ,int width, int height){
    //FIXME: need to free this
    DisplayItem* new_item = (DisplayItem*) (malloc(sizeof(DisplayItem)));
    new_item->t = BACKGROUND;
    new_item->x = x;
    new_item->y = y;
    new_item->w = width;
    new_item->h = height;
    new_item->next = old_list.first;

    DisplayList ret = {old_list.len + 1, new_item};
    return ret;
}

DisplayList add_border(DisplayList old_list, int x, int y, int width, int height, int bt, int br, int bb, int bl){
    //FIXME: need to free this
    DisplayItem* new_item = (DisplayItem*) (malloc(sizeof(DisplayItem)));
    new_item->t = BORDER;
    new_item->x = x;
    new_item->y = y;
    new_item->w = width;
    new_item->h = height;
    new_item->bt = bt;
    new_item->bb = bb;
    new_item->bl = bl;
    new_item->br = br;
    new_item->next = old_list.first;

    DisplayList ret = {old_list.len + 1, new_item};
    return ret;
}
DisplayList add_text_fragment(DisplayList old_list, int x, int y, int width, int height){
    //FIXME: need to free this
    DisplayItem* new_item = (DisplayItem*) (malloc(sizeof(DisplayItem)));
    new_item->t = TEXT;
    new_item->x = x;
    new_item->y = y;
    new_item->w = width;
    new_item->h = height;
    new_item->next = old_list.first;

    DisplayList ret = {old_list.len + 1, new_item};
    return ret;
}

DisplayList merge_lists(DisplayList list1, DisplayList list2) {
    DisplayItem* prev = list2.first;
    DisplayItem* last = list1.first;
    while (last != NULL) {
        prev = last;
        last = last->next;
    }

    if (prev->next == NULL)
        prev->next = list2.first;

    DisplayList ret = {list1.len + list2.len, list1.first};
    return ret;
}

const char* to_string(DisplayList x) {
    //FIXME: need to free this
    char* res = (char *)(malloc((sizeof(char)) * x.len * 130));

    char* buf = (char *)(malloc(sizeof(char) * 120));
    unsigned int k = 0;
    DisplayItem* item = x.first;
    for (unsigned int i = 0; i < x.len; i++) {
        if (i == 0) {
            res[k] = '[';
            k += 1;
        } else {
            res[k] = ',';
            res[k+1] = ' ';
            k += 2;
        }

        switch (item->t) {
            case BACKGROUND:
                sprintf(buf,"BG: x:%d y:%d w:%d h:%d", item->x, item->y, item->w, item->h);
                strcpy(res+k, buf);
                k += strlen(buf);
                break;
            case BORDER:
                sprintf(buf,"BORD: x:%d y:%d w:%d h:%d bt:%d bb:%d bl:%d br:%d", item->x, item->y, item->w, item->h, item->bt, item->bb, item->bl, item->br);
                strcpy(res+k, buf);
                k += strlen(buf);
                break;
            case TEXT:
                sprintf(buf,"TEXT: x:%d y:%d w:%d h:%d", item->x, item->y, item->w, item->h);
                strcpy(res+k, buf);
                k += strlen(buf);
                break;
        }

        ASSERT((item->next != NULL) || i+1 == x.len, "Invalid list");
        item = item->next;
    }
    free(buf);
    res[k] = ']';
    res[k+1] = '\n';
    res[k+2] = '\0';
    return res;
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


