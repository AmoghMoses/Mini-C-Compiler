#include<stdio.h>
int main()
{
    int i = 20;
    int var1 = 9;
    int arr[6] = {1,23,3};
    // int arr[2][5] = {{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}};
    int arr1[5] = {1, 2, 3, 4, 5};
    while(i < 5)
    {
        if(i == 1 || i == 2)
            continue;
        printf("hello %d %d %d\n", arr[0], i, var1);
        i++;
        if(i == 4)
            break;
    }

    printf("hello world\n");
}
    /*
    This File Contains Test cases about Datatypes,Keyword,Identifier,Nested For and while loop,
    Conditional Statement,Single line Comment,MultiLine Comment etc.*/