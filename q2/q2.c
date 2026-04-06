#include <stdio.h>
#include <stdlib.h>

void next_greater(int* arr, int n, int* result);

int main(int argc, char* argv[]) {
    int n = argc - 1;
    if (n <= 0) return 0;

    int* arr = malloc(n * sizeof(int));
    int* res = malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        arr[i] = atoi(argv[i + 1]);
    }

    next_greater(arr, n, res);

    for (int i = 0; i < n; i++) {
        printf("%d ", res[i]);
    }
    printf("\n");

    return 0;
}