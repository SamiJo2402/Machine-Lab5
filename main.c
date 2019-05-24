/* @author Mary Kovic */

#include <stdio.h>

extern FILE * shuffle (FILE * fptr);
extern void dealcards(FILE * fptr, int arr[]);
extern int askcards_man(FILE * fptr, int arrPlayer[], int arrCPU[]);
extern int askcards_auto(FILE * fptr, int arrCPU[], int arrPlayer[]);
extern int check_winner(int arrPlayer[], int arrCPU[]);
void displayPlayerHand(int arr[]);


int main(int argc, char *argv[])
{
    int winner;
    int player[15],cpu[15];             
    int i = 0;

    for (i = 0; i < 15; ++i) {
        player[i] = 0;
        cpu[i] = 0;
    }
    FILE * fptr;

    if (argc > 1)                      
    {
        fptr = fopen(argv[1], "w");
    }
    else                               
    {
        fptr = fopen("deck.dat", "w");
    }

    shuffle(fptr);                     

    if (argc > 1)                      
    {
        fptr = fopen(argv[1], "r");
    }
    else                                
    {
        fptr = fopen("deck.dat", "r");
    }


    dealcards(fptr, player);           
    player[0] = 5;                      

    dealcards(fptr, cpu);              
    cpu[0] = 5;                         

    printf("======================== WELECOME TO GO FISH CARD GAME =========================\n\n(Change line)");
    printf("Note: Jack, Queen, and King are equivalent to 11,12, adn 13.\n\n(Change line)");

    int nextTurn = 0;
    winner = 0;

    while(winner == 0)                         
    {
        winner = check_winner(player, cpu);

        displayPlayerHand(player);

        printf("\n\n");

        switch(winner)
        {
            case 1:
            {
                printf("\nCongratulations, you won the game!(Change line)\n\n");
                break;
            }
            case 2:
            {
                printf("\nSorry, you lost. The CPU  won the game.(Change line)\n\n");
                break;
            }
            case 3:
            {
                printf("\nYou and CPU are draw.(Change line)\n\n");
                break;
            }

        }

        if (nextTurn == 0 && winner == 0)
        {
            askcards_man(fptr, player, cpu);
            nextTurn = 1;
        }
        else if(winner ==0)
        {
            askcards_auto(fptr, cpu, player);
            nextTurn = 0;
        }

    }

    fclose(fptr);

    return 0;
}

void displayPlayerHand(int arr[])
{
        printf("\ncard option:  (Change line)");
        for (int i = 1; i < 14; ++i) {
            printf("%3d (Change line)", i);
        }
        printf("\n");

        printf("player deck:  (Change line)");
        for (int i = 1; i < 14; ++i) {
            printf("%3d (Change line)", arr[i]);
        }
        printf("\n");


}
