#include <cstdio>
#include <cstdlib>
#include "visits.h"
#include "generated.h"

void visit_0 (Tree* node) {
    Attributes* attrs = &(node->attributes);
    switch (attrs->type) {
        case BLOCK_FLOW:
            visit_blockflow_0((BlockFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_FLOW:
            visit_inlineflow_0((InlineFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_BOX:
            ASSERT(false,"Boxes can't be visited!");
            break;
    }
}

void visit_1 (Tree* node) {
    Attributes* attrs = &(node->attributes);
    switch (attrs->type) {
        case BLOCK_FLOW:
            visit_blockflow_1((BlockFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_FLOW:
            visit_inlineflow_1((InlineFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_BOX:
            ASSERT(false,"Boxes can't be visited!");
            break;
    }
}

void visit_2 (Tree* node) {
    Attributes* attrs = &(node->attributes);
    switch (attrs->type) {
        case BLOCK_FLOW:
            visit_blockflow_2((BlockFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_FLOW:
            visit_inlineflow_2((InlineFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_BOX:
            ASSERT(false,"Boxes can't be visited!");
            break;
    }
}

void visit_3 (Tree* node) {
    Attributes* attrs = &(node->attributes);
    switch (attrs->type) {
        case BLOCK_FLOW:
            visit_blockflow_3((BlockFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_FLOW:
            visit_inlineflow_3((InlineFlow*) attrs->attr_struct, node->children, node->num_children);
            break;
        case INLINE_BOX:
            ASSERT(false,"Boxes can't be visited!");
            break;
    }
}

BaseFlow* get_baseflow_child(Tree* child){
    Attributes* attrs = &(child->attributes);
    switch (attrs->type) {
        case BLOCK_FLOW:
            return &(((BlockFlow*) attrs->attr_struct)->base);
        case INLINE_FLOW:
            return &(((InlineFlow*) attrs->attr_struct)->base);
        case INLINE_BOX:
            ASSERT(false, "Not a BaseFlow");
    }
}

InlineBox* get_inlinebox_child(Tree* child){
    Attributes* attrs = &(child->attributes);
    switch (attrs->type) {
        case BLOCK_FLOW:
            ASSERT(false, "Not an InlineBox");
        case INLINE_FLOW:
            ASSERT(false, "Not an InlineBox");
        case INLINE_BOX:
            return (InlineBox*) attrs->attr_struct;
    }
}


