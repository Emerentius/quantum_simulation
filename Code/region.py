import numpy as np

# Class for source, gate and drain.
class Region:
    phi: np.ndarray
    carrier_density: np.ndarray
    DOS: np.ndarray

    def __init__(self, range_start: int, range_end: int) -> None:
        self.range_start = range_start
        self.range_end = range_end

    # phi
    # carrier_density
    # DOS
    # range_start
    # range_end

    def slice(self) -> slice:
        return slice(self.range_start, self.range_end)
