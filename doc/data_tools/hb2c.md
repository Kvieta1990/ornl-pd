HB-2C (WAND^2)
===

(all_wpd)=
- {ref}`all_wpd<all_wpd>`

    This will run the same autoreduction as on Monitor ([monitor.sns.gov](https://monitor.sns.gov)). It runs locally and multiple run numbers can be processed in a batch manner. The program runs as follows,

    ```bash
    all_wpd IPTS RunsToProcess
    ```

    e.g., `all_wpd 22745 '531817, 531819-531820'`

(confirm-hb2c)=
- {ref}`confirm-hb2c<confirm-hb2c>`

    Routine for confirming the data availability for HB-2C experiments. It can run with either of the ways below,

    ```
    confirm-hb2c
    confirm-hb2c <IPTS>
    confirm-hb2c <IPTS> Submission_Number
    ```

    With the first way, the program will ask for a few user inputs while running. With the second way, it will run directly, taking the `<IPTS>` number and assume the submission number of `1`. With the third way, one can also specify the submission number of an `<IPTS>` -- for some experiments, there may be some continuation runs and each run has a certain submission number, `1, 2, 3, ...`.