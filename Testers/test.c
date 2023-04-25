#include <stdio.h>
#include<string.h>

char* token;

// void printNFA()
// {
//     cout << "------------------------------------------------------------------------\n";
//     cout << "State\t|\ta\t|\tb\t|\tepsilon\t|accepting state|" << endl;
//     cout << "------------------------------------------------------------------------\n";
//     for (int i = 0; i < nfa.size(); i++)
//     {
//         cout << i << "\t|\t";

//         for (int j = 0; j < nfa[i].a.size(); j++)
//             cout << nfa[i].a[j] << ' ';

//         cout << "\t|\t";

//         for (int j = 0; j < nfa[i].b.size(); j++)
//             cout << nfa[i].b[j] << ' ';

//         cout << "\t|\t";

//         for (int j = 0; j < nfa[i].epsilon.size(); j++)
//             cout << nfa[i].epsilon[j] << ' ';

//         cout << "\t|\t";

//         if (nfa[i].finalState)
//             cout << "Y";
//         else
//             cout << "N";

//         cout << "\t|\n";
//     }
//     cout << "------------------------------------------------------------------------\n";
// }

void func(char* ch){
  token = ch;
  // strcpy(token,ch);
}

int main()
{
    char ch[5] = "Hello";
    func(ch);
    // printf("%s \n", ch);
    // printf("%s \n", token);
    printf ("%5d", 42);
}

*
// $ yacc -d sample.y // compile yacc program
// $ flex samplelex.l // compile lex program
// $ cc y.tab.c lex.yy.c -ll –ly // using yacc and lex to generate .c program
// $ ./