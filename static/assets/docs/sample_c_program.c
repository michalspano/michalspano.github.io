// Student X, Lecture Y: DD/MM/YYYY
// C: return & functions, pointers, arrays

// Add standard IO library
#include <stdio.h>

// Functions can return:
// - single value (must be defined in the function signature)
//   - <RETURN_TYPE> <NAME>(<INPUT_PARAMETERS> | void)
//   E.g.: sum(a, b) -> a + b
// - no value (void)
//   - void <NAME>(<INPUT_PARAMETERS> | void)
//   E.g.: print_x(x) -> printf("This is value of x: %d\n", x);
// - A function can take 0 parameters - it is `void` (as the parameters)

// 1.) Example return function
// Mat. functions: +, -, *, /, %
// #include <math.h> (sqrt, log, ...)
// sum(a, b) -> a + b
int sum(int x, int y) {
  return x + y;
}

// 2.) Example void function
// Write a function that prints an arithmetical operation
// print_op(x, y, op): 1 + 1, 2 * 1, 1 - 10, ... [x `op` y]
void print_op(int x, int y, char op) { // <-- function signature
  // Function body/ implementation
  printf("%d %c %d\n", x, op, y);
}

// int main(int argc, char* argv[]) {...}
// We explain later.
// Supporting literature:
// - <https://www.geeksforgeeks.org/command-line-arguments-in-c-cpp>
// - <https://www.w3schools.in/c-programming/command-line-arguments>
int main(void) {
  // 1.) `return`
  print_op(3, 4, '+');

  int s = sum(3, 4);
  printf("%d\n", s);

  // 2.) pointers
  int x = 10;
  
  // &<VAR> - memory address of the variable
  // %p - print value of a pointer
  int *px = &x;
  printf("%d %p\n", x, px);

  // *<PTR_VAR> - extract the value from a pointer variable
  int y = *px;
  printf("%d\n", y);

  // 3.) arrays/ polia
  // int (single) -> [int], [1, 2, 3, ...] (multiple)
  // Arrays in C are STATIC (they have a fixed length)!
  
  // Store 5 ints
  int xs[5];
  xs[0] = 1; // first element (0-th index)
  xs[1] = 2; // second element (1st index)
             // ...
             // fifth element (4th index)

  // How does this relate to pointers?!
  // xs is a pointer to the first int
  // xs[0] == *xs
  // xs[1] == *(xs++)
  // ...

  // Store 5 ints, add some 2 ints - alternative syntax
  int ys[5] = {1, 2};

  // Won't work - xs is a pointer to an int
  // printf("%d\n", xs);
  // We cannot print a whole array, use a for-loop instead

  // OK
  printf("%d %d\n", xs[0], xs[1]);
  // The same as - see comment above
  printf("%d %d\n", *xs, *(xs++));

  // Conclusion: arrays are just an abstraction of pointers
  // Reading: <https://www.w3schools.com/c/c_pointers.php>
  //          <https://www.programiz.com/c-programming/c-pointers-arrays>
  //          <https://pdos.csail.mit.edu/6.828/2014/readings/pointers.pdf>
  //          ^ talks about more rigorous use of pointers, focus on chapters 1-4
 
  // The end. ;)
  return 0;
}
