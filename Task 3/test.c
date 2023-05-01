#include<stdio.h>

int add (int x, int y)
{
    return x + y ;
}
int main()
{
    int i = 20;
    int var1 = 9;
    int arr[6] = {1,23,3,4,5,6};
    int arr1[5] = {1, 2, 3, 4, 5};
    while(i < 5)
    {
        i++;
        if(i==3)
            continue;
    }
    for(i = 0; i < 5; i++){}
    int xx = add(i, var1);
    // printf("%d, %d", var1);
    printf("Hello world\n");
    // arr[arr[arr[1]]] = 3;
}