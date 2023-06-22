---
title: "Python Vehicle Model Distribution"
date: 2022-05-09T13:43:25+05:30
weight: 30
description: >
  Learn how to distribute a Vehicle Model written in Python.
---

Now you a have a Python package containing your first Python _Vehicle Model_ and it is time to distribute it. There is nothing special about the distribution of this package, since it is just an ordinary Python package. Check out the [Python Packaging User Guide](https://packaging.python.org/en/latest/) to learn more about packaging and package distribution in Python.

## Distribute to single _Vehicle App_

If you want to distribute your Python _Vehicle Model_ to a single _Vehicle App_, you can do so by copying the entire folder `my_vehicle_model` under the `/app/src` folder of your _Vehicle App_ repository and treat it as a sub-package of the _Vehicle App_.

1. Create a new folder `my_vehicle_model` under `/app/src` in your _Vehicle App_ repository.
2. Copy the `my_vehicle_model` folder to the `/app/src` folder of your _Vehicle App_ repository.
3. Import the package `my_vehicle_model` in your _Vehicle App_:

```python
from <my_app>.my_vehicle_model import vehicle

...

my_app = MyVehicleApp(vehicle)
```

## Distribute inside an organization

If you want to distribute your Python _Vehicle Model_ inside an organization and use it to develop multiple _Vehicle Apps_, you can do so by creating a dedicated Git repository and copying the files there.

1. Create new Git repository called `my_vehicle_model`
2. Copy the content under `my_vehicle_model` to the repository.
3. Release the _Vehicle Model_ by creating a version tag (e.g., `v1.0.0`).
4. Install the _Vehicle Model_ package to your _Vehicle App_:

   ```python
   pip3 install git+https://github.com/<yourorg>/my_vehicle_model.git@v1.0.0
   ```

5. Import the package `my_vehicle_model` in your _Vehicle App_ and use it as shown in the previous section.

## Distribute publicly as open source

If you want to distribute your Python _Vehicle Model_ publicly, you can do so by creating a Python package and distributing it on the [Python Package Index (PyPI)](https://pypi.org/). PyPi is a repository of software for the Python programming language and helps you find and install software developed and shared by the Python community. If you use the `pip` command, you are already using PyPI.

Detailed instructions on how to make a Python package available on PyPI can be found [here](https://packaging.python.org/tutorials/packaging-projects/).
