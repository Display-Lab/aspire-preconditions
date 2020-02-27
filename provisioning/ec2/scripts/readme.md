# Running the Analysis

1. Import spek graph data from json or nt
    ```
      analysis/load_nt_to_fuseki.sh graph.nt spek
    ```
1. Import causal paths graph
    ```
      analysis/load_json_to_fuseki.sh causal_pathways.json seeps
    ```
1. Run think pudding update only
    ```
      thinkpudding.sh -u
    ```
1. Run summary query
    ```
      analysis/summary_query.sh
    ```
1. Run stepping summary
    ```
      analysis/stepping_summary.sh
    ```
