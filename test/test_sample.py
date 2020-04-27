import pytest

def func(x):
    return x + 1

def test_sample_1():
    assert func(2) == 3

def test_sample_2():
    assert func(3) == 5

def test_sample_3():
    assert func(4) == 5

