import pytest

from math_utils import add


def test_add_happy_path() -> None:
    assert add(2, 3) == 5

def test_add_edge_case_zero() -> None:
    assert add(0, 0) == 0

def test_add_negative() -> None:
    assert add(-1, 1) == 0

def test_add_type_error() -> None:
    with pytest.raises(TypeError):
        add(1, "invalid")  # type: ignore[arg-type]
