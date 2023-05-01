#include<stdio.h>
int main()
{
    int i = 20, j = 6;
    int var1 = 9;
    int arr[6] = {1,23,3};
    int arr2[2][5] = {{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}};
    int arr1[5] = {1, 2, 3, 4, 5};
    while(i < 5)
    {
        if(i == 1 || i == 2){
            continue;
        }    
        printf("hello %d %d %d\n", arr[0], i, var1);
        i++;
        if(i == 4)
            if(j == 6)
                break;
    }
    int x = arr2[i+j][arr[0]+7];
    int y = arr2[arr1[0]][arr2[0][0]];
    printf("hello world\n");
    int n, i;
    for(i = 0; i < 5; i++){}
    int arr[3] = {5,2,3};
    arr[100] = 3;
    printf("%d\n",arr[2]);
}
    /*
    This File Contains Test cases about Datatypes,Keyword,Identifier,Nested For and while loop,
    Conditional Statement,Single line Comment,MultiLine Comment etc.*/