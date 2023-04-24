#include <stdio.h>

int main()
{
     char arr[3][10] = {"Geek",
                     "Geeks", "Geekfor"};
  printf("String array Elements are:\n");
   
  for (int i = 0; i < 3; i++)
  {
    printf("%s\n", arr[i]);
  }
}