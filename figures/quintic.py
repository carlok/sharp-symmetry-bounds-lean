# /// script
# requires-python = ">=3.11"
# dependencies = ["numpy==2.5.3", "matplotlib==3.11.2"]
# ///
"""Draw the quintic Re(z^3 (|z|^2 + i)) = 0, its real points and its complex points.

Run with: uv run figures/quintic.py
Writes quintic-real.png and quintic-complex.png next to this file.

In Cartesian coordinates the curve is

    f(x, y) = (x^2 + y^2)(x^3 - 3xy^2) - 3x^2 y + y^3 = 0,

the case d = 5, a = i of the extremal family Re(z^(d-2) (|z|^2 + a)) = 0: an
irreducible quintic with six rotations, the maximum 2d - 4.
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

HERE = Path(__file__).resolve().parent


def f(x, y):
    return (x**2 + y**2) * (x**3 - 3 * x * y**2) - 3 * x**2 * y + y**3


def real_curve(path):
    """The zero set of f in the real plane."""
    t = np.linspace(-2, 2, 801)
    X, Y = np.meshgrid(t, t)
    fig, ax = plt.subplots(figsize=(5, 5))
    ax.contour(X, Y, f(X, Y), levels=[0], colors="black", linewidths=1.5)
    ax.set_aspect("equal")
    ax.set_xlabel("x")
    ax.set_ylabel("y")
    ax.grid(color="0.9")
    ax.set_title("Re(z³(|z|² + i)) = 0")
    fig.tight_layout()
    fig.savefig(path, dpi=120, metadata={"Software": None})
    plt.close(fig)


def complex_curve(path):
    """The complex points (x, y) of f = 0, a surface in C^2, seen from R^3.

    As a polynomial in y, f = -3x y^4 + y^3 - 2x^3 y^2 - 3x^2 y + x^5. For each
    complex x on a grid, its roots y are drawn at (Re x, Im x, Re y) and
    coloured by Im y.
    """
    pts = []
    for a in np.linspace(-1.5, 1.5, 90):
        for b in np.linspace(-1.5, 1.5, 90):
            x = complex(a, b)
            for r in np.roots([-3 * x, 1, -2 * x**3, -3 * x**2, x**5]):
                pts.append((a, b, r.real, r.imag))
    P = np.array(pts)
    P = P[np.abs(P[:, 2]) < 2]
    fig = plt.figure(figsize=(6, 5))
    ax = fig.add_subplot(projection="3d")
    sc = ax.scatter(P[:, 0], P[:, 1], P[:, 2], c=P[:, 3], s=1, cmap="coolwarm",
                    vmin=-2, vmax=2)
    ax.set_xlabel("Re x")
    ax.set_ylabel("Im x")
    ax.set_zlabel("Re y")
    ax.set_title("complex points of f = 0")
    fig.colorbar(sc, ax=ax, shrink=0.6, pad=0.12, label="Im y")
    fig.tight_layout()
    fig.savefig(path, dpi=110, metadata={"Software": None})
    plt.close(fig)


if __name__ == "__main__":
    real_curve(HERE / "quintic-real.png")
    complex_curve(HERE / "quintic-complex.png")
