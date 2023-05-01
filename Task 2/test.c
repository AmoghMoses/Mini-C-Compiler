#include<stdio.h>
int main()
{
    int i = 20;
    int var1 = 9;
    int arr[] = {1,23,3};
    int arr[2][5] = {{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}};
    int arr1[5] = {1, 2, 3, 4, 5};
    while(i < 5)
    {
        if(i == 1 || i == 2)
            continue;
        printf("hello %d %d %d\n", arr[arr[0][0]][0], i, var1);
        i++;
        if(i == 4)
            break;
    }
    i = arr[i][2];
    i = arr[2][arr[i][2]];
    i = arr[arr[i][i]][i];
    i = arr[2][i];
    i = arr1[arr[i][arr1[0]]];
    i = arr1[2];
    char arr[] = "aditya";
    char arr1[20];
    char arr2[15] = "iugcuow";
    char arr3[3][20] = {"chip", "poosgeci", "siddhant"};
    char arr3[][20] = {"igwei", "prabwegkhar"};
    float arr2[2][2] = {{1.23, 132}, {12, 78}};
    float var = 12;
    float x[1][5] = {0.0};
    int sxeni[20][23] = {0};
    int arr3242[20] = {1};
 
    
    printf("hello world\n");
}
    /*
    This File Contains Test cases about Datatypes,Keyword,Identifier,Nested For and while loop,
    Conditional Statement,Single line Comment,MultiLine Comment etc.*/