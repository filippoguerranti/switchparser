# Switch parser using Lex/Yacc

## Assignment
Using lex/yacc implement a parser for managing the `switch` statement in a simplified version. 

* The variable used in the switch is one integer variable in a predefined set of two variables `x`, `y`.

* The values to `x`, `y` are assigned before the if statement (assume 0 if there is no assignment)
    ```
    x = 1;
    y = 2;
    ```

* The switch instruction has the following syntax
    ```
    switch(var) {
        case 0: 
            z=cost0;
            break;

        ...

        case N: 
            z=costN;
            break;

        default: 
            z=costD;
            break;
    }
    ```

* The instruction contains only the assignment of a constant value to the variable `z`.

* At the end print the value of the variable `z`.

## How to use it?
After having downloaded the folder, follow this instructions:

1. Give permissions to the `exe.sh` file:
    
    ```>>> chmod +x ./exe.sh ```

2. Run the `exe.sh` file:

    ```>>> ./exe.h ```
    
    This line of code will generate the following files:
    
    * `lex.yy.c`
    * `switch.tab.c`
    * `switch.tab.h`
    * `switch`

3. Run the parser and give it as input one of the files in the `tests` folder:

    ```>>> ./switch < tests/switch_ok1.c```

4. The output should be something like this:

    ```z=209```

## Informations
Author: Filippo Guerranti <<filippo.guerranti@student.unisi.it>>

Project #1 for the course of **Language Processing Technologies** at the University of Siena (Italy), held by Prof. Marco Maggini.