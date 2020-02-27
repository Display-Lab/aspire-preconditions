# aspire-preconditions
Performance data analysis of aspire data to estimate tailoring rate

## Proceedure

### Data preparation
1. mount storage
1. copy data to /tmp
1. munge data to calc denom and exclude denom < 10
1. sort data and remove duplicate rows
1. remove pre 2019 data

### Analysis
1. annotate performers
1. generate candidates
1. evaluate candidates
1. summarize graph

## External Resources 
- aspire spek
- aspire performance data
- AWS account
- bitstomach
- candidate smasher
- fuseki
- think pudding

## Cloud Setups
### AWS EC2 Instance
Running a 120gb memory machine to run fuseki.

### AWS S3 Neptune
Running a small Neptune cluster to provide graph db and sparql endpoint.
