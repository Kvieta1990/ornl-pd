# maskUtils

Many sample environments used routinely on SNAP affect the scattered beam in a way that affects specific pixels. These effects are managed by masking the data during the `SNAPRed` reduction workflow and `maskUtils` contains the functions to support this. Generally, there are two types of masks used: 

1. "pixel" masks, which remove all events in specified pixels from the reduction process and
2. "bin" masks, which remove events from specific bins within specified pixels. (This is often referred to as a "Swiss Cheese" mask as it literally creates holes in the volumetric TOF data)

These masks are handled separately by the underlying mantid code and this necessitates distinct approaches within `snapwrap`. An important detail is that, generally, a _list_ of masks will be specified when reducing data, and these masks will be combined to exclude all corresponding events.


```{tableofcontents}
```