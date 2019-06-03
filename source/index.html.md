# HMDA API Documentation

## Introduction

For more information on HMDA, checkout the [About HMDA page](http://www.consumerfinance.gov/data-research/hmda/learn-more) on the CFPB website.

## The HMDA Platform

The new HMDA Platform (“V2”) was totally updated over the past year to utilize a more flexible and resilient approach (Kubernetes Microservices) in order to better serve our customers. This repository contains the code for the entirety of the HMDA platform backend. This platform has been designed to accommodate the needs of the HMDA filing process by financial institutions, as well as the data management and publication needs of the HMDA data asset.

The HMDA Platform uses sbt's multi-project builds, each project representing a specific task. The platform is an Akka Cluster application that can be deployed on a single node or as a distributed application. For more information on how Akka Cluster is used, see the documentation [here](Documents/cluster.md)

The HMDA Platform is composed of the following modules:

### Parser (JS/JVM)

Module responsible for reading incoming data and making sure that it conforms to the HMDA File Specification

### Data Validation

Module responsible for validating incoming data by executing validation rules as per the Edit Checks documentation

### Persistence

Module responsible for persisting information into the system. It becomes the system of record for HMDA data

### Cluster

Module responsible for managing the various cluster roles, as well as starting the Hmda Platform

### API

This module contains both public APIs for HMDA data for general use by third party clients and web applications, as well as endpoints for receiving data and providing information about the filing process for Financial Institutions

### API Model

This module contains objects and JSON protocols for use by the API project

### Query

This module is responsible for interacting with the back-end database, as well as conversion between model objects and database objects.

### Panel

This module is responsible for parsing and persisting a CSV-format panel file

### Model (JS/JVM)

This module is responsible for maintaining the objects used in our platform

### Census

This module is responsible for geographic translation (e.g. state number -> state code)

### Publication

This module generates Aggregate and Disclosure reports, as required by HMDA statute.

## Dependencies

### Java 9 SDK

The HMDA Platform runs on the Java Virtual Machine (JVM), and requires the Java 9 JDK to build and run the project. This project is currently being built and tested on [Oracle JDK 9](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html). See [Oracle's JDK Install Overview](http://docs.oracle.com/javase/9/docs/technotes/guides/install/install_overview.html) for install instructions.

The HMDA Platform should also run on JDK 8.

### Scala

The HMDA Platform is written in [Scala](http://www.scala-lang.org/). To build it, you will need to [download](http://www.scala-lang.org/download/) and [install](http://www.scala-lang.org/download/install.html) Scala 2.12.x

In addition, you'll need Scala's interactive build tool [sbt](https://www.scala-sbt.org/). Please refer to sbt's [installation instructions](https://www.scala-sbt.org/1.x/docs/Setup.html) to get started.

## Project structure

The HMDA Platform is divided into individual projects, each responsible for a subset of the functionality, as follows:

### hmda-platform

This is the main filing application, exposing the APIs necessary to upload, validate and store HMDA files.

### check-digit

Microservice that exposes functionality to create a check digit from a loan id, and to validate `Univeral Loan Identifiers`


## Building and Running

### Running from the SBT prompt

* To run the project from the `SBT` prompt for development purposes, issue the following commands on a terminal:

```shell
$ sbt
sbt:root> project hmda-platform
sbt:hmda-platform> reStart
```


### Building and running the .jar

* To build JVM artifacts, from the sbt prompt first choose the project you want to build and use the assembly command:

```shell
$ sbt
sbt:root> project check-digit
sbt:check-digit>assembly
```
This task will create a `fat jar`, which can be executed on any `JDK9` compliant `JVM`:

`java -jar target/scala-2.12/check-digit.jar`

### Building and running the Docker image

* To build a `Docker` image that runs the `hmda-platform` as a single node cluster, from the sbt prompt:

```shell
$sbt
sbt:root> project hmda-platform
sbt:hmda-platform> docker:publishLocal
```
This task will create a `Docker` image. To run a container with the `HMDA Platform` filing application as a single node cluster:

`docker run --rm -ti -p 8080:8080 -p 8081:8081 -p 8082:8082 -p 19999:19999 hmda/hmda-platform`

The same approach can be followed to build and run Docker containers for the other microservices that form the HMDA Platform.

Certain environment variables can be passed in to set the log level of the micro service

```
ZOOKEEPER_LOG_LEVEL (Defaulted to WARN)
KAFKA_LOG_LEVEL (Defaulted to INFO)
CASSANDRA_LOG_LEVEL (Defaulted to INFO)
PLATFORM_LOG_LEVEL (Defaulted to WARN)
INSTITUTION_LOG_LEVEL (Defaulted to INFO)
CHECKDIGIT_LOG_LEVEL (Defaulted to DEBUG)
```

### Running the application in clustered mode (mesos)

* The script in the [mesos](../../mesos) folder describes the deployment through [Marathon](https://mesosphere.github.io/marathon/) on a DCOS / Mesos cluster.

For a 3 node cluster deployed through the [DC/OS CLI](https://docs.mesosphere.com/1.10/cli/), the following command can be used:

```shell
dcos marathon app add mesos/hmda-platform-host-mode.json
```

For more details, please refer to the [Marathon Documentation](https://mesosphere.github.io/marathon/)

## Resources

### API Documentation


* [HMDA Platform Public API Documentation](#hmda-platform-public-api)
* [HMDA Platform ULI API Documentation](api/uli.md)
* [HMDA Platform Filers API Documentation](api/filers-api.md)

### Development

* [Local Kubernetes CI/CD](development/kubernetes.md)

### Data Specifications

* [TS File Spec](spec/2018_File_Spec_TS.csv)
* [LAR File Spec](spec/2018_File_Spec_LAR.csv)
* [Institution Data Model Spec](spec/2018_Institution_Data_Model_Spec.csv)


# Platform Public API

This documentation describes de public HMDA Platform HTTP API

## Institutions

### Search Option 1

* `/institutions?domain=<domain>`

   * `GET` - Returns a list of institutions filtered by their email domain. If none are found, an HTTP 404 error code (not found) is returned

   Example response, with HTTP code 200:

   ```json
   {
     "institutions": [
       {
         "activityYear" : 2019,
         "LEI" : "54930084UKLVMY22DS16",
         "agency" : 1,
         "institutionType" : 17,
         "institutionId2017" : "12345",
         "taxId" : "99-00000000",
         "rssd" : 12345,
         "emailDomains" : ["bank0.com"],
         "respondent" : {
           "name" : "xvavjuitZa",
           "state" : "NC",
           "city" : "Raleigh"
         },
         "parent" : {
           "idRssd" : 1520162208,
           "name" : "Parent Name"
         },
         "assets" : 450,
         "otherLenderCode" : 1406639146,
         "topHolder" : {
           "idRssd" : 442825905,
           "name" : "TopHolder Name"
         },
         "hmdaFiler" : true
       }
     ]
   }
   ```
### Search Option 2

  * `/institutions?domain=<domain>&lei=<lei>&respondentName=<respondentName>&taxId=<taxId>`

   * `GET` - Returns a list of institutions filtered by field values. If none are found, an HTTP 404 error code (not found) is returned

   Example response, with HTTP code 200:

   ```json
   {
     "institutions": [
       {
         "activityYear" : 2019,
         "LEI" : "54930084UKLVMY22DS16",
         "agency" : "1",
         "institutionType" : "17",
         "institutionId2017" : "12345",
         "taxId" : "99-00000000",
         "rssd" : "Pb",
         "emailDomains" : ["email@bank0.com"],
         "respondent" : {
           "name" : "xvavjuitZa",
           "state" : "NC",
           "city" : "Raleigh"
         },
         "parent" : {
           "idRssd" : "1520162208",
           "name" : "Parent Name"
         },
         "assets" : "450",
         "otherLenderCode" : "1406639146",
         "topHolder" : {
           "idRssd" : "442825905",
           "name" : "TopHolder Name"
         },
         "hmdaFiler" : true
       }
     ]
   }
   ```
### Search Option 3

* `/institutions/<institutionID>`

    - `GET`

    Retrieves the details of an institution. If not found, returns HTTP code 404

    Example Response with HTTP code 200, in `JSON` format:

    ```json
    {
      "activityYear" : 2019,
      "LEI" : "54930084UKLVMY22DS16",
      "agency" : 1,
      "institutionType" : 17,
      "institutionId2017" : "12345",
      "taxId" : "99-00000000",
      "rssd" : 12345,
      "emailDomains" : ["bank0.com"],
      "respondent" : {
        "name" : "xvavjuitZa",
        "state" : "NC",
        "city" : "Raleigh"
      },
      "parent" : {
        "idRssd" : 1520162208,
        "name" : "Parent Name"
      },
      "assets" : 450,
      "otherLenderCode" : 1406639146,
      "topHolder" : {
        "idRssd" : 442825905,
        "name" : "TopHolder Name"
      },
      "hmdaFiler" : true
    }     
    ```

## TS Parsing and Validation

### Parsing

* `/ts/parse`

    * `POST` Returns a `JSON` representation of a TS, or a list of errors if the TS fails to parse

    Example body, in `JSON` format:

    ```json
    {
      "ts" : "1|Bank 0|2018|4|Jane|111-111-1111|janesmith@bank.com|123 Main St|Washington|DC|20001|9|100|99-999999|10Bx939c5543TqA1144M"
    }
    ```

    Example response, in `JSON` format:

    ```json
    {
        "id": 1,
        "institutionName": "Bank 0",
        "year": 2018,
        "quarter": 4,
        "contact": {
            "name": "Jane",
            "phone": "111-111-1111",
            "email": "janesmith@bank.com",
            "address": {
                "street": "123 Main St",
                "city": "Washington",
                "state": "DC",
                "zipCode": "20001"
            }
        },
        "agency": 9,
        "totalLines": 100,
        "taxId": "99-999999",
        "LEI": "10Bx939c5543TqA1144M"
    }
    ```

### Validation

* `/ts/validate`

    * `POST` - Returns a `JSON` representation of a TS, or a list of edits if the TS fails to validate

    Example body, in `JSON` format:

    ```json
    {
      "ts": "1|Bank1|2018|4|testname|555-555-5555|test@email.com|1234 Hocus Potato Way|Testtown|UT|84096|9|1000|02-1234567|BANK1LEIFORTEST12345"
    }
    ```

    Example successful response, in `JSON` format: See above

    Example failed response, in `JSON` format:

    ```json
    {
        "syntactical": {
            "errors": [
              "S300"
            ]
        },
        "validity": {
            "errors": [
                "V600",
                "V601"
            ]
        },
        "quality": {
            "errors": []
        }
    }
    ```


## LAR Parsing and Validation

### Parsing

* `/lar/parse`

    * `POST` - Returns a `JSON` representation of a LAR, or a list of errors if the LAR fails to parse

    Example body, in `JSON` format:

    ```json
    {
      "lar": "2|10Bx939c5543TqA1144M|10Bx939c5543TqA1144M999143X38|20180721|1|1|1|1|1|110500|1|20180721|123 Main St|Beverly Hills|CA|90210|06037|06037264000|1|1|1|1|1||1|1|1|1|1||3|3|5|7|7|7|7||||5|7|7|7|7||||3|3|1|1|3|3|30|30|36|1|0.428|1|1|750|750|1|9|1|9|10|10|10|10||2399.04|NA|NA|NA|NA|4.125|NA|42.95|80.05|360|NA|1|2|1|1|350500|1|1|5|NA|1|1|12345|1|1|1|1|1||1|1|1|1|1||1|1|1"
    }
    ```

    Example response, in `JSON` format:


    ```json
    {
        "larIdentifier": {
            "id": 2,
            "LEI": "10Bx939c5543TqA1144M",
            "NMLSRIdentifier": "12345"
        },
        "loan": {
            "ULI": "10Bx939c5543TqA1144M999143X38",
            "applicationDate": "20180721",
            "loanType": 1,
            "loanPurpose": 1,
            "constructionMethod": 1,
            "occupancy": 1,
            "amount": 110500,
            "loanTerm": "360",
            "rateSpread": "0.428",
            "interestRate": "4.125",
            "prepaymentPenaltyTerm": "NA",
            "debtToIncomeRatio": "42.95",
            "loanToValueRatio": "80.05",
            "introductoryRatePeriod": "NA"
        },
        "larAction": {
            "preapproval": 1,
            "actionTakenType": 1,
            "actionTakenDate": 20180721
        },
        "geography": {
            "street": "123 Main St",
            "city": "Beverly Hills",
            "state": "CA",
            "zipCode": "90210",
            "county": "06037",
            "tract": "06037264000"
        },
        "applicant": {
            "ethnicity": {
                "ethnicity1": 1,
                "ethnicity2": 1,
                "ethnicity3": 1,
                "ethnicity4": 1,
                "ethnicity5": 1,
                "otherHispanicOrLatino": "",
                "ethnicityObserved": 3
            },
            "race": {
                "race1": 5,
                "race2": 7,
                "race3": 7,
                "race4": 7,
                "race5": 7,
                "otherNativeRace": "",
                "otherAsianRace": "",
                "otherPacificIslanderRace": "",
                "raceObserved": 3
            },
            "sex": {
                "sex": 1,
                "sexObserved": 3
            },
            "age": 30,
            "creditScore": 750,
            "creditScoreType": 1,
            "otherCreditScoreModel": "9"
        },
        "coApplicant": {
            "ethnicity": {
                "ethnicity1": 1,
                "ethnicity2": 1,
                "ethnicity3": 1,
                "ethnicity4": 1,
                "ethnicity5": 1,
                "otherHispanicOrLatino": "",
                "ethnicityObserved": 3
            },
            "race": {
                "race1": 5,
                "race2": 7,
                "race3": 7,
                "race4": 7,
                "race5": 7,
                "otherNativeRace": "",
                "otherAsianRace": "",
                "otherPacificIslanderRace": "",
                "raceObserved": 3
            },
            "sex": {
                "sex": 1,
                "sexObserved": 3
            },
            "age": 30,
            "creditScore": 750,
            "creditScoreType": 1,
            "otherCreditScoreModel": "9"
        },
        "income": "36",
        "purchaserType": 1,
        "hoepaStatus": 1,
        "lienStatus": 1,
        "denial": {
            "denialReason1": 10,
            "denialReason2": 10,
            "denialReason3": 10,
            "denialReason4": 10,
            "otherDenialReason": ""
        },
        "loanDisclosure": {
            "totalLoanCosts": "2399.04",
            "totalPointsAndFees": "NA",
            "originationCharges": "NA",
            "discountPoints": "NA",
            "lenderCredits": "NA"
        },
        "nonAmortizingFeatures": {
            "balloonPayment": 1,
            "interestOnlyPayment": 2,
            "negativeAmortization": 1,
            "otherNonAmortizingFeatures": 1
        },
        "property": {
            "propertyValue": "350500.0",
            "manufacturedHomeSecuredProperty": 1,
            "manufacturedHomeLandPropertyInterest": 1,
            "totalUnits": 5,
            "multiFamilyAffordableUnits": "NA"
        },
        "applicationSubmission": 1,
        "payableToInstitution": 2,
        "AUS": {
            "aus1": 1,
            "aus2": 1,
            "aus3": 1,
            "aus4": 1,
            "aus5": 1,
            "otherAUS": ""
        },
        "ausResult": {
            "ausResult1": 1,
            "ausResult2": 1,
            "ausResult3": 1,
            "ausResult4": 1,
            "ausResult5": 1,
            "otherAusResult": ""
        },
        "reverseMortgage": 1,
        "lineOfCredit": 1,
        "businessOrCommercialPurpose": 1
    }
    ```

### Validation

* `/lar/validate`

    * `POST` - Returns a `JSON` representation of a LAR, or a list of edits if the LAR fails to validate

    Example body, in `JSON` format:

    ```json
    {
      "lar": "2|10Bx939c5543TqA1144M|10Bx939c5543TqA1144M999143X38|20180721|1|1|1|1|1|110500|1|20180721|123 Main St|Beverly Hills|CA|90210|06037|06037264000|1|1|1|1|1||1|1|1|1|1||3|3|5|7|7|7|7||||5|7|7|7|7||||3|3|1|1|3|3|30|30|36|1|0.428|1|1|750|750|1|9|1|9|10|10|10|10||2399.04|NA|NA|NA|NA|4.125|NA|42.95|80.05|360|NA|1|2|1|1|350500|1|1|5|NA|1|1|12345|1|1|1|1|1||1|1|1|1|1||1|1|1"
    }
    ```

    Example successful response, in `JSON` format: See above

    Example failed response, in `JSON` format:

    ```json
    {
        "syntactical": {
            "errors": []
        },
        "validity": {
            "errors": [
                "V619-1",
                "V619-2",
                "V619-3",
                "V676-3",
                "V676-5",
                "V677-2"
            ]
        },
        "quality": {
            "errors": [
                "Q617"
            ]
        }
    }
    ```

## HMDA File Parsing and Validation

### Parsing

* `/hmda/parse`

    * `POST` - Parses a HMDA file. Returns list of errors per line in `JSON` format, if found.

    Example file:

    ```
    1|Bank 0|2018|4|Jane|111-111-1111|janesmith@bank.com|123 Main St|Washington|DC|20001|9|100|99-999999|10Bx939c5543TqA1144M
    2|10Bx939c5543TqA1144M|10Bx939c5543TqA1144M999143X38|20180721|A|1|1|1|1|110500|1|20180721|123 Main St|Beverly Hills|CA|90210|06037|06037264000|1|1|1|1|1||1|1|1|1|1||3|3|5|7|7|7|7||||5|7|7|7|7||||3|3|1|1|3|3|30|30|36|1|0.428|1|1|750|750|1|9|1|9|10|10|10|10||2399.04|NA|NA|NA|NA|4.125|NA|42.95|80.05|360|NA|1|2|1|1|350500|1|1|5|NA|1|1|12345|1|1|1|1|1||1|1|1|1|1||1|1|1
    ```

    Example Response, in `JSON` format:

    ```json
    {
        "validated": [
            {
                "lineNumber": 2,
                "errors": "loan type is not numeric"
            }
        ]
    }
    ```



* `/hmda/parse/csv`

    * `POST` - Parses a HMDA file. Returns list of errors per line in `CSV` format, if found.

    Example file:

    ```
    1|Bank 0|2018|4|Jane|111-111-1111|janesmith@bank.com|123 Main St|Washington|DC|20001|9|100|99-999999|10Bx939c5543TqA1144M
    2|10Bx939c5543TqA1144M|10Bx939c5543TqA1144M999143X38|20180721|A|1|1|1|1|110500|1|20180721|123 Main St|Beverly Hills|CA|90210|06037|06037264000|1|1|1|1|1||1|1|1|1|1||3|3|5|7|7|7|7||||5|7|7|7|7||||3|3|1|1|3|3|30|30|36|1|0.428|1|1|750|750|1|9|1|9|10|10|10|10||2399.04|NA|NA|NA|NA|4.125|NA|42.95|80.05|360|NA|1|2|1|1|350500|1|1|5|NA|1|1|12345|1|1|1|1|1||1|1|1|1|1||1|1|1
    ```

    Example response, in `CSV` format:

    ```csv
    lineNumber|errors
    2|loan type is not numeric
    ```

# Check Digit(ULI)

## Check digit generation

* `/uli/checkDigit`

   * `POST` - Calculates check digit and full ULI from a loan id.

Example payload, in `JSON` format:

```json
{
  "loanId": "10Bx939c5543TqA1144M999143X"
}
```

Example response:

```json
{
    "loanId": "10Cx939c5543TqA1144M999143X",
    "checkDigit": 10,
    "uli": "10Cx939c5543TqA1144M999143X10"
}
```

A file with a list of Loan Ids can also be uploaded to this endpoint for batch check digit generation.

Example file contents:

```
10Cx939c5543TqA1144M999143X
10Bx939c5543TqA1144M999143X
```

Example response in `JSON` format:

```json
{
    "loanIds": [
        {
            "loanId": "10Bx939c5543TqA1144M999143X",
            "checkDigit": 38,
            "uli": "10Bx939c5543TqA1144M999143X38"
        },
        {
            "loanId": "10Cx939c5543TqA1144M999143X",
            "checkDigit": 10,
            "uli": "10Cx939c5543TqA1144M999143X10"
        }
    ]
}
```

* `/uli/checkDigit/csv`

   * `POST` - calculates check digits for loan ids submitted as a file

Example file contents:

```
10Cx939c5543TqA1144M999143X
10Bx939c5543TqA1144M999143X
```

Example response in `CSV` format:

```csv
loanId,checkDigit,uli
10Bx939c5543TqA1144M999143X,38,10Bx939c5543TqA1144M999143X38
10Cx939c5543TqA1144M999143X,10,10Cx939c5543TqA1144M999143X10
```

### ULI Validation

* `/uli/validate`

   * `POST` - Validates a ULI (correct check digit)

Example payload, in `JSON` format:

```json
{
	"uli": "10Bx939c5543TqA1144M999143X38"
}
```

Example response:

```json
{
    "isValid": true
}
```

A file with a list of ULIs can also be uploaded to this endpoint for batch ULI validation.

Example file contents:

```
10Cx939c5543TqA1144M999143X10
10Bx939c5543TqA1144M999143X38
10Bx939c5543TqA1144M999133X38
```

Example response in `JSON` format:

```json
{
    "ulis": [
        {
            "uli": "10Cx939c5543TqA1144M999143X10",
            "isValid": true
        },
        {
            "uli": "10Bx939c5543TqA1144M999143X38",
            "isValid": true
        },
        {
            "uli": "10Bx939c5543TqA1144M999133X38",
            "isValid": false
        }
    ]
}
```

* `/uli/validate/csv`

   * `POST` - Batch validation of ULIs

Example file contents:

```
10Cx939c5543TqA1144M999143X10
10Bx939c5543TqA1144M999143X38
10Bx939c5543TqA1144M999133X38
```

Example response in `CSV` format:

```csv
uli,isValid
10Cx939c5543TqA1144M999143X10,true
10Bx939c5543TqA1144M999143X38,true
10Bx939c5543TqA1144M999133X38,false
```

# Filers API

## Filters

* `/filers/<filing year>`

   * `GET` - Returns a list of filers for the filing year defined in the URI.

Note : This endpoint is currently only supported for the 2018 filing year

Example response:

```json
{  
   "institutions":[  
      {  
         "lei":"12345677654321",
         "name":"Test Bank 1",
         "period":"2018"
      },
      {  
         "lei":"5734315621455",
         "name":"Test Bank 12",
         "period":"2018"
      }
   ]
}
```

* `/filers/<filing year>/<lei>/msaMds`

   * `GET` - Returns all MsaMds for the specified filer

Example response:

```json
{  
   "institution":{  
      "lei":"12345677654321",
      "name":"Test Bank 1",
      "period":"2018"
   },
   "msaMds":[  
      {  
         "id":"47664",
         "name":"FARMINGTON HILLS,MI"
      },
      {  
         "id":"19180",
         "name":"DANVILLE,IL"
      }
   ]
}
```
