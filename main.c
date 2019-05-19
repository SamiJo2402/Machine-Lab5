//
// Author: Dan Mendoza
// Palomar ID: 006798227
// Description: This code is the main function for Go Fish Application game

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
    int player[15],cpu[15];             //index 0 to track card count, 1-13 to track pairs, index 14 is to track score
    int i = 0;

    for (i = 0; i < 15; ++i) {
        player[i] = 0;
        cpu[i] = 0;
    }
    FILE * fptr;

    if (argc > 1)                       // if file name indicated in main parameters
    {
        fptr = fopen(argv[1], "w");
    }
    else                                // if file name not indicated in main parameters
    {
        fptr = fopen("deck.dat", "w");
    }

    shuffle(fptr);                      // place random number between 0-13 for card rank and place into file 52 times to represent a card deck

    if (argc > 1)                       // if file name indicated in main parameters
    {
        fptr = fopen(argv[1], "r");
    }
    else                                // if file name not indicated in main parameters
    {
        fptr = fopen("deck.dat", "r");
    }


    dealcards(fptr, player);            // deal 5 cards to player
    player[0] = 5;                      // set total card count for player to 5

    dealcards(fptr, cpu);               // deal 5 cards to cpu
    cpu[0] = 5;                         // set total card count for cpu to 5

    printf("======================== WELECOME TO GO FISH CARD GAME =========================\n\n");
    printf("Note: Jack, Queen, and King are equivalent to 11,12, adn 13.\n\n");

    int nextTurn = 0;
    winner = 0;

    // Play Go Fish
    while(winner == 0)                            // while loop runs until winner is declared which breaks the while loop
    {
        winner = check_winner(player, cpu);

        displayPlayerHand(player);
        //displayPlayerHand(cpu);

        printf("\n\n");

        switch(winner)
        {
            case 1:
            {
                printf("\nCongratulations, you won the game!\n\n");
                break;
            }
            case 2:
            {
                printf("\nSorry, you lost. The CPU  won the game.\n\n");
                break;
            }
            case 3:
            {
                printf("\nYou and CPU are draw.\n\n");
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

// This function is to display what is on player's hand
void displayPlayerHand(int arr[])
{
        printf("\ncard option:  ");
        for (int i = 1; i < 14; ++i) {
            printf("%3d ", i);
        }
        printf("\n");

        printf("player deck:  ");
        for (int i = 1; i < 14; ++i) {
            printf("%3d ", arr[i]);
        }
        printf("\n");


}
