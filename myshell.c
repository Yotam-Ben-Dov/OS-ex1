//Yotam Ben Dov 316387950

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

#define MAX_LEN 110
#define NUM_BUILT_IN 3

void parseInput(char *input, char *dest[]);
pid_t executeCommands(char *parsedInput[]);

int main(int argc, char const *argv[])
{
    // gets env path
    char *path = getenv("PATH");
    // appends received folders onto created path variable
    for (int i = 1; i < argc; i++)
    {
        strcat(path, ":/");
        strcat(path, argv[i]);
    }
    // sets path
    setenv("PATH", path, 0);
    // counts commands and creates arrays for input and history
    int numCommands = 0;
    char input[MAX_LEN], *parsedInput[MAX_LEN], history[MAX_LEN][MAX_LEN];
    // as long as user doesn't quit
    while (1)
    {
        // prints prompt and scans for input
        printf("$ ");
        fflush(stdout);
        scanf(" %[^\n]%*c", input);

        // if input is empty, ask for new input
        if (strlen(input) == 0)
            continue;

        // if command is one of the built-in, initiates command
        parseInput(input, parsedInput);

        // creates vars for pid
        pid_t pid;
        char entry[MAX_LEN];
        // sets them for local actions (will change for bash cmnds)
        pid = getpid();

        if (strcmp(parsedInput[0], "history") == 0)
        {
            for (int i = 0; i < numCommands; i++)
            {
                printf("%s\n", history[i]);
            }
            sprintf(entry, "%d", pid);
            printf("%s history\n", entry);
        }
        else if (strcmp(parsedInput[0], "cd") == 0)
        {
            if (chdir(parsedInput[1]) < 0)
                perror("cd failed");
        }
        else if (strcmp(parsedInput[0], "exit") == 0)
            break;
        // if not a built in command, goes to exec func
        else
        {
            pid = executeCommands(parsedInput);
        }
        // gets pid and copies it into entry
        sprintf(entry, "%d", pid);
        strcat(entry, " ");
        strcat(entry, input);
        strcpy(history[numCommands], entry);
        numCommands++;
    }
    return 0;
}

void parseInput(char *input, char *dest[])
{
    // creates copy and parse by space
    char copy[MAX_LEN];
    strcpy(copy, input);
    char *token;

    token = strtok(copy, " ");
    // insert results into dest
    int i = 0;

    while (token != NULL)
    {
        dest[i] = token;
        token = strtok(NULL, " ");
        i++;
    }
    // sets last parameter to avoid leftovers from last assignments to dest
    dest[i] = 0x0;
}

pid_t executeCommands(char *parsedInput[])
{
    // creates child process.
    pid_t pid = fork();
    // if failed to create child process, exit with perror.
    if (pid < 0)
        perror("fork failed");
    // else runs command on child process.
    else if (pid == 0)
    {
        // if failed exits with perror.
        if (execvp(parsedInput[0], parsedInput) < 0)
        {
            char command[MAX_LEN];
            strcpy(command, parsedInput[0]);
            strcat(command, " failed");
            perror(command);
        }
        exit(0);
    }
    else // else is parent, waits for child to die and returns pid
    {
        wait(NULL);
        return pid;
    }
}