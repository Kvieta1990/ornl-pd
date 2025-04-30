HB-2A (POWDER)
===

- `confirm-hb2a`

    Routine for confirming the data availability for HB-2A experiments. It can run with either of the ways below,

    ```
    confirm-hb2a
    confirm-hb2a <IPTS>
    confirm-hb2a <IPTS> Submission_Number
    ```

    With the first way, the program will ask for a few user inputs while running. With the second way, it will run directly, taking the `<IPTS>` number and assume the submission number of `1`. With the third way, one can also specify the submission number of an `<IPTS>` -- for some experiments, there may be some continuation runs and each run has a certain submission number, `1, 2, 3, ...`.