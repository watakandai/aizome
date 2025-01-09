import specless as sl  # or load from specless.inference import TPOInference
import pandas as pd

# Manually prepare a list of demonstrations
demonstrations = [
    ["e1", "e2", "e3", "e4", "e5"],             # trace 1
    ["e1", "e4", "e2", "e3", "e5"],             # trace 2
    ["e1", "e2", "e4", "e3", "e5"],             # trace 3
 ]
dataset = sl.ArrayDataset(demonstrations, columns=["symbol"])

# # or load from a file
# >>> csv_filename = "examples/readme/example.csv"
# >>> dataset = sl.BaseDataset(pd.read_csv(csv_filename))

# Run the inference
inference = sl.POInferenceAlgorithm()
specification = inference.infer(dataset)            # returns a Specification

# prints the specification
print(specification) # doctest: +ELLIPSIS

# exports the specification to a file
sl.save_graph(specification, filepath='spec')

# drawws the specification to a file
sl.draw_graph(specification, filepath='spec')