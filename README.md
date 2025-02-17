
Hi everyone, I am Florian, CTO of Vortel and today Let me show you our data extraction tool through the lens of a staffing agency, where managing identity verification for new hires is time-consuming. I'll demonstrate how Vortel automatically extracts and validates candidate information from their documents.

[Demo]
    Beforehand I defined the different types of value I need to extract. Here are a couple of basic information.
    As I want to create a new employee entry I just upload its corresponding files.
    Here a basic onboarding form as well as a driver license image.
    Behind the scenes, the extraction engine, powered by OCR, document parsing, and Large Language Models extracts the information against the designated schema.
    The system clearly indicates the validated fields, the ones needing review, and any missing information.

    After that I can save the employee in the database, but also export it in my existing systems as a CSV file.

[Key Benefits] "Instead of manually typing information from various documents, Vortel:

    Automatically fits the extracted data into your schema
    Reduces human error in data entry
    Leverages AI to understand and process documents like a human would
    Maintains data accuracy with built-in validation

[Flexibility] "While we're demonstrating identity verification today, Vortel's powerful combination of OCR and AI makes it adaptable to any structured document type. Tomorrow, you could be:

    Processing purchase orders
    Extracting invoice data
    Handling shipping documents Simply define your data schema, and Vortel's intelligent engine adapts to extract exactly what you need, in the format you want."


MVP
I. invoke 1., 2. and 3. from a python for dev, then lambda + api on prod
Prereq: example files already uploaded in s3

1. creating BDA blueprint -> [basic json saved locally but boto create_blueprint must be called](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/bedrock-data-automation/client/create_blueprint.html)
2. [create_data_automation_project referencing previously created blueprint](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/bedrock-data-automation/client/create_data_automation_project.html)
3. [invoke data automation async](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/bedrock-data-automation-runtime/client/invoke_data_automation_async.html)

II. api + auth set up
 - api gateway + lambda router + api key
 - create bp
 - create da project
 - invoke da project
 - chekc project status

III. flutter front end
 - api key 
 - blueprint designer
 - da creation ?
 - invoke da project