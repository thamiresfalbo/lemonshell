---
title: Code Examples
date: 2022-05-18
---

## Array Methods in C

```c
// Array methods
#include <stdio.h>

void printArr(int a, int someArr[])
{
    int count = 0;
    while (count < a)
    {
        printf("%d ", someArr[count]);
        count++;
    } 
}

int * joinArr(int arrA[], int arrB[], int sizeA, int sizeB)
{
    // int sizeA = sizeof(arrA) / sizeof(int);
    // int sizeB = sizeof(arrB) / sizeof(int);
    int i, j, index = 0;
    
    int totalSize = sizeA + sizeB;
    static int mergedArr[100];

    for (i = 0; i < sizeA; i++)
    {
        mergedArr[index++] = arrA[i];
    }

    for (j = 0; j < sizeB; j++)
    {
        mergedArr[index++] = arrB[j];
    }
    return mergedArr;
}

void divideArr(int n)
{
    int i, even_Count = 0, odd_Count = 0, evenArr[10], oddArr[10];
    for (i = 1; i < n + 1; i++)
    {
        if (i % 2 != 0)
        {
            oddArr[odd_Count] = i;
            odd_Count++;
        }
        else
        {
            evenArr[even_Count] = i;
            even_Count++;
        }
    }
    printf("Even has %d elements.\n", even_Count);
    printArr(even_Count, evenArr);
    printf("\n");
    printf("Odd has %d elements.\n", odd_Count);
    printArr(odd_Count, oddArr);
}

int * orderArr(int arr[], int count)
{
    int z, i, j;
    static int result[100];
    for (i = 0; i < count; i++)
    {
        for (j = i + 1; j < count; j++)
        {
            if (arr[i] > arr[j])
            {
                int a = arr[i];
                arr[i] = arr[j];
                arr[j] = a;
            }
        }
    }
    return arr;
}

int main()
{
    int i = 0;
    int x[] = {0, 15, 70, 34, 23, 123, 90};
    int y[] = {2,4,6,8,0};
    size_t xSize = sizeof(x) / sizeof(int);
    size_t ySize = sizeof(y) / sizeof(int);
    size_t totalSize = xSize + ySize;
    int *v = joinArr(x, y, xSize,ySize);
    int *z = orderArr(v, totalSize);
    printf("<----------------->\n");
    printArr(totalSize,z);
}
```