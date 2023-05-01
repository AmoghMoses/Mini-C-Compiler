#include<stdio.h>

int main()
{
    int a = 5;
	int b = 6;
	int c = 3;
	int d = a + b - c * a + b;
	printf("d = %d\n", d);
	int e = a + b - c * a + b;
}