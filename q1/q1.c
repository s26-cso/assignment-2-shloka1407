#include <stdio.h>

struct Node { int val; struct Node* left; struct Node* right; };

struct Node* make_node(int val);
struct Node* insert(struct Node* root, int val);
struct Node* get(struct Node* root, int val);
int getAtMost(int val, struct Node* root);

int main() {
    struct Node* root = NULL;
    root = insert(root, 10);
    root = insert(root, 5);
    root = insert(root, 15);
    root = insert(root, 3);
    root = insert(root, 7);

    printf("get(7):       %p (expect non-null)\n", get(root, 7));
    printf("get(99):      %p (expect null)\n",     get(root, 99));
    printf("getAtMost(8): %d (expect 7)\n",        getAtMost(8, root));
    printf("getAtMost(5): %d (expect 5)\n",        getAtMost(5, root));
    printf("getAtMost(2): %d (expect -1)\n",       getAtMost(2, root));
}