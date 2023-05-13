Data reduction running time
===

## POWDER | HB-2A | HFIR

For HB-2A, the data files involved in the reduction are usually plain text file so the data reduction is indeed flying. For a typical file tested here,

```
/HFIR/HB2A/IPTS-29540/exp894/Datafiles/HB2A_exp0894_scan0004.dat
```

Running time: ~1.5 seconds

> Also, the reduction can be done purely from autoreduction, with all similar runs merged together automatically. By `similar` runs, we mean those repeated measurements under the same condition.

## WAND$^2$ | HB-2C | HFIR

Here follows is a typical file used for testing the HB-2C data reduction running time,

```
/HFIR/HB2C/IPTS-22745/nexus/HB2C_531817.nxs.h5
```

File size: ~25 MB

Running time: ~35 seconds

## NOMAD | BL-1B | SNS

All data files involved here for testing the data reduction running time on NOMAD are listed here,

---

IPTS-28173

<br />

Sample runs: 172544-172549

Empty container runs: 172397-172400

Empty instrument run: 172402

Vanadium run: 172401

<br />

Total size involved: ~50 Gb

---

Absorption correction: method=`SampleAndContainer` for sample and method=`SampleOnly` for vanadium

Running time: ~1.9 minutes

<br />

Absorption correction: method=`None` for sample (i.e., no absorption) and method=`SampleOnly` for vanadium

Running time: ~0.8 minutes

> N.B. The reduction time here refers to the manual reduction where proper caching (via autoreduction)
and calculation of absorption in a group manner is assumed.

## POWGEN | BL-11A | SNS

---

IPTS-2767

<br />

Sample runs: 53601

Empty container runs: 51877

Empty instrument run: 52869

Vanadium run: 52863

<br />

Total size involved: ~4 Gb

---

Absorption correction: method=`SampleAndContainer` for sample and method=`SampleOnly` for vanadium

Running time: ~1.0 minutes

> N.B. The reduction time here refers to the manual reduction where proper caching (via pre-calculation
for obtaining the absorption workspace) and calculation of absorption in a group manner is assumed.