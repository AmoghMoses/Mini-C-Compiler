#include<stdio.h>
int add(int x, int y)
{
    return x + y;
}
void main()
{
    int i = 20;
    int var1 = 9;
    int arr[6] = {1,23,3,4,5,6};
    //int arr2[2][5] = {{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}};
    int arr1[5] = {1, 2, 3, 4, 5};
    while(i < 5)
    {
        // if(i == 1 || i == 2)
        //     continue;
        //printf("hello %d %d %d\n", arr[0], i, var1);
        i++;
        if(i == 4)
            break;
    }
    // int x = arr[i];
    // int y = arr2[arr1[0]][arr2[0][0]];
    printf("hello world\n");
    int n = add(2, 3);
    for(i = 0; i < 5; i++){}
    int arr3[3] = {5,2,3};
    //arr[2] = 3;
    // printf("%d\n",arr[2]);

}