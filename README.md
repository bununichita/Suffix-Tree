
# Racket Suffix Tree Operations

### Author: Nichita-Adrian Bunu, 323CA Facultatea de Automatica si Calculatoare UNSTPB 
**Contact:** [nichita_adrian.bunu@stud.acs.upb.ro](mailto:nichita_adrian.bunu@stud.acs.upb.ro)

---

## Overview

This Racket project provides a set of functions to manipulate suffix trees and perform pattern-matching operations. The code is designed to find the longest common prefix between words, support suffix tree searches, and enable pattern matching using recursive methods.

---

## Features and Functionality

The main features include:

- **Longest Common Prefix Calculation**:
  - Determines the longest common prefix between two words.
  - Extracts the remainder of each word after the prefix.
- **Longest Common Prefix for a List**:
  - Finds the longest common prefix shared by all words in a list.
- **Pattern Matching with Suffix Trees**:
  - Searches for patterns within a suffix tree by matching against branch labels.
  - Identifies matches by comparing labels, handling cases where only partial matches exist.
- **Pattern Existence Check**:
  - Verifies whether a pattern exists within the suffix tree, using auxiliary recursive functions.

---

## Code Structure

### `longest-common-prefix`

Calculates the longest common prefix between two words (character lists). Returns a list containing the prefix and the remaining parts of each word.

### `longest-common-prefix-of-list`

Recursively finds the longest common prefix among a list of words that share the same starting character. Stops the search as soon as it is clear that the current prefix is the final common prefix.

### `match-pattern-with-label`

Performs a single step in matching a pattern within a suffix tree:
- Locates the branch label that starts with the first letter of the pattern.
- Determines how well the pattern matches the label:
  - Returns `#t` if the pattern is entirely within the label.
  - Returns a list of the label, remaining pattern, and subtree if the match is partial.
  - Returns `#f` and the longest matching prefix if there is no match.

### `st-has-pattern?`

Determines whether a pattern is present in a suffix tree, using `match-pattern-with-label` for verification.

---
