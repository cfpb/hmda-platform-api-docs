## Introduction

For more information on HMDA, checkout the [About HMDA page](http://www.consumerfinance.gov/data-research/hmda/learn-more) on the CFPB website.

# Platform Public API

This documentation describes the public HMDA Platform HTTP API

### Data Specifications

* [TS File Spec](spec/2018_File_Spec_TS.csv)
* [LAR File Spec](spec/2018_File_Spec_LAR.csv)
* [Institution Data Model Spec](spec/2018_Institution_Data_Model_Spec.csv)

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
