---
layout: post
title: "The tricky 'finally' statement"
---

Here are four examples, where the `finally` statement is _tricky_. Generally speaking, one should __avoid__ using the `return` statement and throwing an `Exception` in the `finally` block - these are just some __illustrative examples__.

### Example 1

```java
public static int a() {
        try {
            System.out.println("Print some message");
            return 1;
        } catch (Exception exception) {
            System.out.println("Print another message");
        } finally {
            return 2;
        }
    }
```

### Example 2

```java
public static int b() {
        try {
            return 1;
        } catch (Exception exception) {
            return 2;
        } finally {
            return 3;
        }
    }
```

### Example 3

```java
public static void c() throws Exception {
        try {
            return;
        } finally {
            throw new Exception("From finally!");
        }
    }
```

### Example 4
```java
public static void d() {
        try {
            return;
        } finally {
            System.out.println("From finally!");
        }
    }
```
___


Lastly, inside the `main` method, we can call the above methods:

```java
public static void main(String[] args) {
        System.out.println(a());  // Print some message
                                  // 2

        System.out.println(b());  // 3

        // we need to handle the Exception first
        try {
            c();
        } catch (Exception exception) {
            System.out.println(exception.getMessage()); // From finally!
        }

        d();                      // From finally!
    }
```

### But, why?

In the first example, the code under the `try` block is executed, and so should be the return statement therein. However, the `finally` _overrides_ the return statement, therefore 2 is returned. 

The same happens in the second example, where the `finally` block _overrides_ the return statement in the `try` block, and in case an `Exception` is caught, the `finally` block _overrides_ the return statement in the `catch` block too - _'it is the last statement to be executed'_.

Interestingly, in the third example, the `finally` block overrides the `return` statement in the `try` block, and throws an `Exception` instead. Therefore, the `Exception` is thrown, and the `return` statement is omitted.

Lastly, the `finally` block in the fourth example is even able to _override_ the `return` statement in the `try` block, with a simple _print statement_, and a message is printed to the standard output. So, the `return` statement is omitted.

## References

[Oracle Java Documentation](https://docs.oracle.com/javase/tutorial/essential/exceptions/finally.html)
