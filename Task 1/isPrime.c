#include<stdio.h>
int main()
{
    int a,i,j,flag=0;
    printf("Input no"); //Input 
 
    i=3.1415E+3;
    j=127;
    float b = 9.5;
    while(i <= a/2)
    {
        if(a%i == 0)
        {
            flag=1;
            break;
        }
        i++;
    }
    if(flag==0)
        printf("Prime"); // It's a prime number.
    else
        printf("Not Prime");
    return 0;
}