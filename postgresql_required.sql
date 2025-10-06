-- Assets Data Structure
CREATE TABLE
    Cash (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        branchCode VARCHAR(255) NOT NULL, -- Alphanumeric
        cashCategory VARCHAR(255) NOT NULL, -- References lookup table
        cashSubCategory VARCHAR(255), -- Non-Mandatory per API Changes
        currency VARCHAR(255) NOT NULL, -- References Currency table
        cashDenomination VARCHAR(255) NOT NULL, -- Mandatory per API Changes
        quantityCoinsNotes INT NOT NULL, -- Mandatory per API Changes
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        vaultPettyCash VARCHAR(255) NOT NULL, -- Text
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        cashSubmissionTime DATETIME NOT NULL, -- New column per API Changes
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Balance_BOT (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        accountNumber VARCHAR(255) NOT NULL, -- Alphanumeric
        accountName VARCHAR(255) NOT NULL, -- Text
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Balance_Other_Banks (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        accountNumber VARCHAR(255) NOT NULL, -- Alphanumeric
        accountName VARCHAR(255) NOT NULL, -- Text
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        bankCode VARCHAR(255) NOT NULL, -- References lookup table
        bankName VARCHAR(255) NOT NULL, -- Text
        branchCode VARCHAR(255) NOT NULL, -- Alphanumeric
        branchName VARCHAR(255) NOT NULL, -- Text
        country VARCHAR(255) NOT NULL, -- References Country table
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        swiftCode VARCHAR(255) NOT NULL, -- Alphanumeric
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        externalRatingCorrespondentBank VARCHAR(255), -- References Table D67, Non-Mandatory
        gradesUnratedBanks VARCHAR(255) -- References Table D68, Non-Mandatory
    );

CREATE TABLE
    Balance_MNOs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        floatBalanceDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        mnoCode VARCHAR(255) NOT NULL, -- Alphanumeric
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgFloatAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdFloatAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsFloatAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Investment_Debt_Securities (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        securityNumber VARCHAR(255) NOT NULL, -- Alphanumeric
        securityName VARCHAR(255) NOT NULL, -- Text
        securityType VARCHAR(255) NOT NULL, -- References Table D30
        issuerName VARCHAR(255) NOT NULL, -- Text
        issuerCountry VARCHAR(255) NOT NULL, -- References Country table
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic Sector table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        nominalInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL -- References Table D32
    );

CREATE TABLE
    Cheques_Items_Clearing (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        chequeNumber VARCHAR(255) NOT NULL, -- Numeric
        issuerName VARCHAR(255) NOT NULL, -- Text
        issuerCountry VARCHAR(255) NOT NULL, -- References Country table
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic Sector table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountBalance DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Interbank_Loans_Receivable (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        borrowersName VARCHAR(255) NOT NULL, -- Text
        borrowersCountry VARCHAR(255) NOT NULL, -- References Country table
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic Sector table
        loanNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        loanType VARCHAR(255) NOT NULL, -- References Table D52
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        disbursementDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        nominalInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL -- References Table D32
    );

CREATE TABLE
    Term_Loan (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        customerIdentificationNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        customerName VARCHAR(255) NOT NULL, -- Text
        gender VARCHAR(255) NOT NULL, -- References Table D93
        disabilityStatus VARCHAR(255) NOT NULL, -- References Table D94
        loanNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        accountNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        loanType VARCHAR(255) NOT NULL, -- References Table D52
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic Sector table
        branchCode VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        customerCountry VARCHAR(255) NOT NULL, -- References Country table
        district VARCHAR(255) NOT NULL, -- References Region table
        region VARCHAR(255) NOT NULL, -- References Region table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        contractDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        disbursementDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        nominalInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        annualEffectiveInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        amortizationType VARCHAR(255) NOT NULL, -- References Table D96
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        pastDueDays INT NOT NULL, -- Numeric
        customerRole VARCHAR(255) NOT NULL, -- Text
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        orgSuspendedInterest DECIMAL(18, 2), -- Numeric, Non-Mandatory
        usdSuspendedInterest DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsSuspendedInterest DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Loan_Transaction (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        loanNumber VARCHAR(255) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        transactionType VARCHAR(255) NOT NULL, -- Text
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgTransactionAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdTransactionAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsTransactionAmount DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Overdraft (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        accountNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        clientIdentificationNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        clientName VARCHAR(255) NOT NULL, -- Text
        gender VARCHAR(255) NOT NULL, -- References Table D93
        disabilityStatus VARCHAR(255) NOT NULL, -- References Table D94
        branchCode VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        customerCountry VARCHAR(255) NOT NULL, -- References Country table
        district VARCHAR(255) NOT NULL, -- References Region table
        region VARCHAR(255) NOT NULL, -- References Region table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        contractDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        nominalInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        annualEffectiveInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        pastDueDays INT NOT NULL, -- Numeric
        customerRole VARCHAR(255) NOT NULL, -- Text
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Microfinance_Segment_Loans (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        customerIdentificationNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        customerName VARCHAR(255) NOT NULL, -- Text
        gender VARCHAR(255) NOT NULL, -- References Table D93
        disabilityStatus VARCHAR(255) NOT NULL, -- References Table D94
        loanNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        branchCode VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        customerCountry VARCHAR(255) NOT NULL, -- References Country table
        district VARCHAR(255) NOT NULL, -- References Region table
        region VARCHAR(255) NOT NULL, -- References Region table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        contractDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        disbursementDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        nominalInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        annualEffectiveInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        amortizationType VARCHAR(255) NOT NULL, -- References Table D96
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        pastDueDays INT NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL, -- References Table D32
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Commercial_Bills_Purchased (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        securityNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        issuerName VARCHAR(255) NOT NULL, -- Text
        issuerCountry VARCHAR(255) NOT NULL, -- References Country table
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic Sector table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL -- References Table D32
    );

CREATE TABLE
    Customer_Liabilities_Acceptances (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        draftHolder VARCHAR(255) NOT NULL, -- Text or Alphanumeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic Sector table
    );

CREATE TABLE
    Underwriting_Accounts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        underwritingType VARCHAR(255) NOT NULL, -- References Table D88
        issuerName VARCHAR(255) NOT NULL, -- Text
        issuerCountry VARCHAR(255) NOT NULL, -- References Country table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic Sector table
    );

CREATE TABLE
    Equity_Investment (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        investeeName VARCHAR(255), -- Text or Alphanumeric, Non-Mandatory
        countryOfIncorporation VARCHAR(255) NOT NULL, -- References Country table
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic Sector table
        securityNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        numberOfShares INT NOT NULL, -- Numeric
        sharePrice DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgAccruedIncomeAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedIncomeAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedIncomeAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        tradingIntent VARCHAR(255) NOT NULL, -- References lookup table
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL -- References Table D32
    );

CREATE TABLE
    Premises_Furniture_Equipment (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        assetCategory VARCHAR(255) NOT NULL, -- References Attribute Table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgCostValue DECIMAL(18, 2) NOT NULL, -- Numeric
        usdCostValue DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsCostValue DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAccumulatedDepreciation DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccumulatedDepreciation DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccumulatedDepreciation DECIMAL(18, 2) NOT NULL, -- Numeric
        acquisitionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgNetBookValue DECIMAL(18, 2) NOT NULL, -- Numeric
        usdNetBookValue DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsNetBookValue DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Claim_Treasury (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        governmentInstitutionName VARCHAR(255) NOT NULL, -- Text
        securityNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        assetClassificationCategory VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic Sector table
    );

CREATE TABLE
    Asset_Owned_Acquired (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        assetCategory VARCHAR(255) NOT NULL, -- References Attribute Table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgCostValue DECIMAL(18, 2) NOT NULL, -- Numeric
        usdCostValue DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsCostValue DECIMAL(18, 2) NOT NULL, -- Numeric
        acquisitionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Digital_Credit (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        customerName VARCHAR(255) NOT NULL, -- Text
        gender VARCHAR(255) NOT NULL, -- References Table D93
        disabilityStatus VARCHAR(255) NOT NULL, -- References Table D94
        customerIdentificationNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        branchCode VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        customerCountry VARCHAR(255) NOT NULL, -- References Country table
        district VARCHAR(255) NOT NULL, -- References Region table
        region VARCHAR(255) NOT NULL, -- References Region table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        contractDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        disbursementDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        nominalInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        annualEffectiveInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        amortizationType VARCHAR(255) NOT NULL, -- References Table D96
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        pastDueDays INT NOT NULL, -- Numeric
        assetClassification VARCHAR(255) NOT NULL, -- References Table D32
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        interestSuspended DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Interbranch_Float_Items (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        branchCode VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL, -- Numeric
        classification VARCHAR(255) NOT NULL -- References Table D32
    );

CREATE TABLE
    Other_Assets (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        assetType VARCHAR(255) NOT NULL, -- References Table D31
        assetTypeSubCategory VARCHAR(255) NOT NULL, -- References Table D31
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        pastDueDays INT NOT NULL, -- References Table D32
        assetClassificationCategory VARCHAR(255) NOT NULL, -- References Table D32
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL, -- Numeric
        botProvision DECIMAL(18, 2) NOT NULL -- Numeric
    );

-- Liabilities Data Structure
CREATE TABLE
    Deposit_Withdrawal_Transactions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        clientIdentificationNumber VARCHAR(255) NOT NULL, -- Alphanumeric or numeric
        accountNumber VARCHAR(255) NOT NULL, -- Alphanumeric or numeric
        accountName VARCHAR(255) NOT NULL, -- Text
        customerCategory VARCHAR(255) NOT NULL, -- Text
        customerCountry VARCHAR(255) NOT NULL, -- References Country table
        branchCode VARCHAR(255) NOT NULL, -- Alphanumeric or numeric
        clientType VARCHAR(255) NOT NULL, -- References Table D54
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        district VARCHAR(255) NOT NULL, -- References Region table
        region VARCHAR(255) NOT NULL, -- References Region table
        accountProductName VARCHAR(255) NOT NULL, -- Text
        transactionType VARCHAR(255) NOT NULL, -- Text
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        depositType VARCHAR(255) NOT NULL, -- References Table D81
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgTransactionAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdTransactionAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsTransactionAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        transactionPurposes TEXT NOT NULL, -- Text
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic Sector table
        lienNumber VARCHAR(255), -- Numeric, Non-Mandatory
        orgAmountLien DECIMAL(18, 2), -- Numeric, Non-Mandatory
        usdAmountLien DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountLien DECIMAL(18, 2), -- Numeric, Non-Mandatory
        contractDate DATETIME, -- DDMMYYYYHHMM, Non-Mandatory
        maturityDate DATETIME, -- DDMMYYYYHHMM, Non-Mandatory
        annualInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestRateType VARCHAR(255) NOT NULL, -- References Table D102
        orgInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdInterestAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsInterestAmount DECIMAL(18, 2) NOT NULL -- Numeric
    );

t
CREATE TABLE
    Digital_Saving (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        customerIdentificationNumber VARCHAR(255) NOT NULL, -- Alphanumeric
        customerName VARCHAR(255) NOT NULL, -- Text or alphanumeric
        gender VARCHAR(255) NOT NULL, -- References Table D93
        disabilityStatus VARCHAR(255) NOT NULL, -- References Table D94
        bankCode VARCHAR(255) NOT NULL, -- References Bank list
        branchCode VARCHAR(255) NOT NULL, -- Alphanumeric
        servicesFacilitator VARCHAR(255) NOT NULL, -- References Table D74
        productName VARCHAR(255) NOT NULL, -- References Table D167
        transactionType VARCHAR(255) NOT NULL, -- References Table D73
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgDepositAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdDepositAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsDepositAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgTransactionAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdTransactionAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsTransactionAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgDepositBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        usdDepositBalance DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsDepositBalance DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Bankers_Cheques_Drafts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        customerName VARCHAR(255) NOT NULL, -- Text
        customerIdentificationNumber VARCHAR(255) NOT NULL, -- Alphanumeric or Numeric
        beneficiaryName VARCHAR(255) NOT NULL, -- Text
        chequeNumber VARCHAR(255) NOT NULL, -- Numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmount DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Payment_Orders_Transfers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        customerIdentificationNumber VARCHAR(255) NOT NULL, -- Alphanumeric or Numeric
        beneficiaryName VARCHAR(255) NOT NULL, -- Text
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        purposeTransfer VARCHAR(255) NOT NULL, -- References ITRS PAYMENT PURPOSE
        beneficiaryAccNumber VARCHAR(255) NOT NULL, -- Alphanumeric or Numeric
        benReceivingInstitution VARCHAR(255) NOT NULL, -- Text
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        senderName VARCHAR(255) NOT NULL, -- Text
        senderAccNumber VARCHAR(255) NOT NULL, -- Alphanumeric or Numeric
        senderCountry VARCHAR(255) NOT NULL, -- References Country table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountClosing DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Institutional_Borrowings (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        borrowingType VARCHAR(255) NOT NULL, -- References Table D52
        lenderName VARCHAR(255) NOT NULL, -- Text
        lenderCountry VARCHAR(255) NOT NULL, -- References Country table
        lenderRelationship VARCHAR(255) NOT NULL, -- References Table D33
        transactionUniqueRef VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        debtRegistrationNumber VARCHAR(255), -- Numeric or Alphanumeric, Non-Mandatory
        borrowersAccountNumber VARCHAR(255) NOT NULL, -- Numeric or Alphanumeric
        borrowersBankCode VARCHAR(255) NOT NULL, -- References BIC
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        loanContractDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        loanReceiptDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        loanMaturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        nominalInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        annualEffectiveInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        amortizationType VARCHAR(255) NOT NULL, -- References Table D96
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAccruedInterestOutstandingAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestOutstandingAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestOutstandingAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAmountClosing DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Subordinated_Debt (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        lenderName VARCHAR(255) NOT NULL, -- Text
        country VARCHAR(255) NOT NULL, -- References Country table
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        lenderRelationship VARCHAR(255) NOT NULL, -- References Table D33
        borrowingPurposes VARCHAR(255) NOT NULL, -- References Table D103
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        annualInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestPricingMethod VARCHAR(255) NOT NULL, -- References Table D165
        amortizationType VARCHAR(255) NOT NULL, -- References Table D96
        loanContractDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        loanValueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        orgAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAccruedInterestOutstandingAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAccruedInterestOutstandingAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        tzsAccruedInterestOutstandingAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        orgPrincipalAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdPrincipalAmountClosing DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsPrincipalAmountClosing DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Accrued_Taxes_Expenses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        claimantName VARCHAR(255) NOT NULL, -- Text
        payableCategory VARCHAR(255) NOT NULL, -- References Table 35
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic Sector table
    );

CREATE TABLE
    Unearned_Income_Deferred (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        unearnedIncomeType VARCHAR(255) NOT NULL, -- References Table D178
        beneficiaryName VARCHAR(255) NOT NULL, -- Alphanumeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic Sector table
    );

CREATE TABLE
    Outstanding_Acceptances (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        acceptanceType VARCHAR(255), -- Text, Non-Mandatory
        beneficiaryName VARCHAR(255) NOT NULL, -- Text
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmount DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmount DECIMAL(18, 2) NOT NULL, -- Numeric
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic Sector table
    );

CREATE TABLE
    Interbranch_Float_Items (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        branchCode VARCHAR(255) NOT NULL, -- Alphanumeric or numeric
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountFloat DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountFloat DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountFloat DECIMAL(18, 2) NOT NULL -- Numeric
    );

CREATE TABLE
    Interbank_Loans_Payable (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        lenderName VARCHAR(255) NOT NULL, -- Text
        accountNumber VARCHAR(255) NOT NULL, -- Numeric
        lenderCountry VARCHAR(255) NOT NULL, -- References Country table
        borrowingType VARCHAR(255) NOT NULL, -- Text
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        disbursementDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountRepayment DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountRepayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountClosing DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountClosing DECIMAL(18, 2) NOT NULL, -- Numeric
        tenureDays INT NOT NULL, -- Numeric
        annualInterestRate DECIMAL(18, 2) NOT NULL, -- Numeric
        interestRateType VARCHAR(255) NOT NULL -- References Table D102
    );

CREATE TABLE
    Other_Liabilities (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        liabilityCategory VARCHAR(255) NOT NULL, -- References Table D36
        counterpartyName VARCHAR(255) NOT NULL, -- Text
        counterpartyCountry VARCHAR(255) NOT NULL, -- References Country table
        transactionDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        valueDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        maturityDate DATETIME NOT NULL, -- DDMMYYYYHHMM
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountOpening DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountOpening DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountPayment DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountPayment DECIMAL(18, 2) NOT NULL, -- Numeric
        orgAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        usdAmountBalance DECIMAL(18, 2), -- Numeric, Non-Mandatory
        tzsAmountBalance DECIMAL(18, 2) NOT NULL, -- Numeric
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic Sector table
    );

-- Banks Equity data Structure
CREATE TABLE
    Share_Capital (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        capitalCategory VARCHAR(255) NOT NULL, -- References Table D37
        capitalSubCategory VARCHAR(255) NOT NULL, -- References Table D37
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D161
        shareholderNames VARCHAR(255) NOT NULL,
        clientType VARCHAR(255), -- References Table D54, Non-Mandatory
        shareholderCountry VARCHAR(255) NOT NULL, -- References Country table
        numberOfShares INT NOT NULL,
        sharePriceBookValue DECIMAL(18, 2) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        sectorSnaClassification VARCHAR(255) -- References Economic Sector table, Non-Mandatory
    );

CREATE TABLE
    Other_Capital_Accounts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D161
        reserveCategory VARCHAR(255) NOT NULL, -- References Table D38
        reserveSubCategory VARCHAR(255), -- References Table D38, Non-Mandatory
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Deductions_Core_Capital (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        deductionsType VARCHAR(255) NOT NULL, -- References Table D149
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Dividends (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        dividendType VARCHAR(255) NOT NULL, -- References Table D82
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryAccNumber VARCHAR(255) NOT NULL,
        beneficiaryBankCode VARCHAR(255) NOT NULL -- References BIC table
    );

CREATE TABLE
    Share_Capital (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        capitalCategory VARCHAR(255) NOT NULL, -- References Table D37
        capitalSubCategory VARCHAR(255) NOT NULL, -- References Table D37
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D161
        shareholderNames VARCHAR(255) NOT NULL,
        clientType VARCHAR(255), -- References Table D54
        shareholderCountry VARCHAR(255) NOT NULL, -- References Country table
        numberOfShares INT NOT NULL,
        sharePriceBookValue DECIMAL(18, 2) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        sectorSnaClassification VARCHAR(255) -- References Economic Sector table
    );

CREATE TABLE
    Other_Capital_Accounts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D161
        reserveCategory VARCHAR(255) NOT NULL, -- References Table D38
        reserveSubCategory VARCHAR(255), -- References Table D38
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Deductions_To_Core_Capital (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        deductionsType VARCHAR(255) NOT NULL, -- References Table D149
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Dividends (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        dividendType VARCHAR(255) NOT NULL, -- References Table D82
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryAccNumber VARCHAR(255) NOT NULL,
        beneficiaryBankCode VARCHAR(255) NOT NULL -- References BIC
    );

-- api_endpoints_tables_bank_others.sql
CREATE TABLE
    Cash_Statistics (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        branchCode VARCHAR(255) NOT NULL,
        cashCategory VARCHAR(255) NOT NULL, -- References Table D26
        typeOfCash VARCHAR(255) NOT NULL,
        denomination VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        quantityOfCoinsNotes INT NOT NULL,
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Fraud_Statistics (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        productProcess VARCHAR(255) NOT NULL, -- References Table D154
        fraudType VARCHAR(255) NOT NULL,
        occurrenceDate DATETIME NOT NULL,
        complaintReportingDate DATETIME NOT NULL,
        closureDate DATETIME,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        recoveryAmount DECIMAL(18, 2) NOT NULL,
        netLoss DECIMAL(18, 2) NOT NULL,
        status VARCHAR(255) NOT NULL,
        empNin VARCHAR(255) NOT NULL,
        fraudsterName VARCHAR(255) NOT NULL,
        fraudsterCountry VARCHAR(255) NOT NULL -- References Country table
    );

CREATE TABLE
    Complaints_Statistics (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        complainantName VARCHAR(255) NOT NULL,
        complainantMobile VARCHAR(255),
        complaintNature VARCHAR(255) NOT NULL, -- References Table D127
        occurrenceDate DATETIME NOT NULL,
        complaintReportingDate DATETIME NOT NULL,
        closureDate DATETIME,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        employeeId VARCHAR(255) NOT NULL,
        referredComplaints VARCHAR(255) NOT NULL, -- References Table D57
        complaintStatus VARCHAR(255) NOT NULL -- References Table D107
    );

CREATE TABLE
    Account_Product_Category (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        accountProductCode VARCHAR(255) NOT NULL,
        accountProductName VARCHAR(255) NOT NULL,
        accountProductCategory VARCHAR(255) NOT NULL,
        accountProductDescription TEXT NOT NULL,
        accountProductStatus VARCHAR(255) NOT NULL, -- References Table D171
        accountProductCreationDate DATETIME NOT NULL,
        accountProductClosureDate DATETIME,
        accountProductStatus VARCHAR(255) NOT NULL -- References Table D171
    );

CREATE TABLE
    Incoming_Fund_Transfer (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionId VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        senderName VARCHAR(255) NOT NULL,
        senderCountry VARCHAR(255) NOT NULL, -- References Country table
        senderBank VARCHAR(255) NOT NULL,
        senderBankCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryBank VARCHAR(255) NOT NULL,
        beneficiaryBankCountry VARCHAR(255) NOT NULL, -- References Country table
        transferType VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        purposes VARCHAR(255) NOT NULL, -- References ITRS RECEIPT PURPOSE table
        senderInstruction VARCHAR(255) NOT NULL
    );

CREATE TABLE
    Outgoing_Fund_Transfer (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionId VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        senderName VARCHAR(255) NOT NULL,
        senderCountry VARCHAR(255) NOT NULL, -- References Country table
        senderBank VARCHAR(255) NOT NULL,
        senderBankCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryBank VARCHAR(255) NOT NULL,
        beneficiaryBankCountry VARCHAR(255) NOT NULL, -- References Country table
        transferType VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        purposes VARCHAR(255) NOT NULL, -- References ITRS PAYMENT PURPOSE table
        senderInstruction VARCHAR(255) NOT NULL,
        transactionPlace VARCHAR(255) NOT NULL -- References Country list
    );

CREATE TABLE
    Agents (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        agentName VARCHAR(255) NOT NULL,
        agentId VARCHAR(255) NOT NULL,
        tillNumber VARCHAR(255),
        agentType VARCHAR(255) NOT NULL, -- References Table D43
        agentStatus VARCHAR(255) NOT NULL, -- References Table D64
        agentCategory VARCHAR(255) NOT NULL, -- References Table D113
        agentPrincipal VARCHAR(255) NOT NULL, -- References Table D115
        agentBranchCode VARCHAR(255) NOT NULL,
        agentRegion VARCHAR(255) NOT NULL, -- References Region table
        agentDistrict VARCHAR(255) NOT NULL, -- References Region table
        agentWard VARCHAR(255) NOT NULL, -- References Region table
        agentStreet VARCHAR(255) NOT NULL,
        agentPlotNumber VARCHAR(255) NOT NULL,
        agentBlockNumber VARCHAR(255) NOT NULL,
        agentHouseNumber VARCHAR(255) NOT NULL,
        gpsCoordinates VARCHAR(255),
        country VARCHAR(255) NOT NULL, -- References Country table
        gpsCoordinates VARCHAR(255),
        agentTaxIdentificationNumber VARCHAR(255) NOT NULL,
        businessLicense VARCHAR(255) NOT NULL
    );

CREATE TABLE
    Agent_Transactions_Data (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        agentId VARCHAR(255) NOT NULL,
        agentStatus VARCHAR(255) NOT NULL, -- References Table D64
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D72
        serviceChannel VARCHAR(255) NOT NULL, -- References Table D72
        tillNumber VARCHAR(255),
        currency VARCHAR(255) NOT NULL, -- References Currency table
        tzsAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Branch (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        branchName VARCHAR(255) NOT NULL,
        taxIdentificationNumber INT NOT NULL,
        businessLicense VARCHAR(255) NOT NULL,
        branchCode VARCHAR(255) NOT NULL,
        branchStatus VARCHAR(255) NOT NULL, -- References Table D64
        branchCategory VARCHAR(255) NOT NULL, -- References Table D106
        branchOpeningDate DATETIME NOT NULL,
        branchClosureDate DATETIME,
        region VARCHAR(255) NOT NULL, -- References Region table
        district VARCHAR(255) NOT NULL, -- References Region table
        ward VARCHAR(255) NOT NULL, -- References Region table
        street VARCHAR(255) NOT NULL,
        plotNumber VARCHAR(255) NOT NULL,
        blockNumber VARCHAR(255) NOT NULL,
        houseNumber VARCHAR(255) NOT NULL,
        gpsCoordinates VARCHAR(255) NOT NULL,
        contactPerson VARCHAR(255) NOT NULL,
        telephoneNumber INT NOT NULL,
        altTelephoneNumber INT,
        branchCategory VARCHAR(255) NOT NULL -- References Table D106
    );

CREATE TABLE
    POS (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        posBranchCode VARCHAR(255) NOT NULL,
        posNumber VARCHAR(255) NOT NULL,
        qrFsrCode VARCHAR(255) NOT NULL,
        posType VARCHAR(255) NOT NULL, -- References Table D114
        posStatus VARCHAR(255) NOT NULL, -- References Table D64
        posCategory VARCHAR(255) NOT NULL,
        posPrincipal VARCHAR(255) NOT NULL, -- References Table D115
        region VARCHAR(255) NOT NULL, -- References Region table
        district VARCHAR(255) NOT NULL, -- References Region table
        ward VARCHAR(255) NOT NULL, -- References Region table
        street VARCHAR(255) NOT NULL,
        plotNumber VARCHAR(255) NOT NULL,
        blockNumber VARCHAR(255) NOT NULL,
        houseNumber VARCHAR(255) NOT NULL,
        gpsCoordinates VARCHAR(255) NOT NULL,
        linkedAccount VARCHAR(255) NOT NULL,
        issueDate DATETIME NOT NULL,
        returnDate DATETIME
    );

CREATE TABLE
    POS_Transaction_Data (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        posNumber VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D72
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgCurrencyTransactionAmount DECIMAL(18, 2) NOT NULL,
        tzsTransactionAmount DECIMAL(18, 2) NOT NULL,
        valueAddedTaxAmount DECIMAL(18, 2) NOT NULL,
        exciseDutyAmount DECIMAL(18, 2) NOT NULL,
        electronicLevyAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    ATM (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        atmName VARCHAR(255) NOT NULL,
        branchCode VARCHAR(255) NOT NULL,
        atmCode VARCHAR(255) NOT NULL,
        atmStatus VARCHAR(255) NOT NULL, -- References Table D64
        atmCategory VARCHAR(255) NOT NULL, -- References Table D109
        atmChannel VARCHAR(255) NOT NULL, -- References Table D110
        region VARCHAR(255) NOT NULL, -- References Region table
        district VARCHAR(255) NOT NULL, -- References Region table
        ward VARCHAR(255) NOT NULL, -- References Region table
        street VARCHAR(255) NOT NULL,
        plotNumber VARCHAR(255) NOT NULL,
        blockNumber VARCHAR(255) NOT NULL,
        houseNumber VARCHAR(255) NOT NULL,
        gpsCoordinates VARCHAR(255) NOT NULL,
        issueDate DATETIME NOT NULL,
        closureDate DATETIME,
        atmCategory VARCHAR(255) NOT NULL, -- References Table D109
        atmChannel VARCHAR(255) NOT NULL -- References Table D110
    );

CREATE TABLE
    ATM_Transaction_Data (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        atmCode VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D72
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsTransactionAmount DECIMAL(18, 2) NOT NULL,
        atmChannel VARCHAR(255) NOT NULL, -- References Table D110
        valueAddedTaxAmount DECIMAL(18, 2) NOT NULL,
        exciseDutyAmount DECIMAL(18, 2) NOT NULL,
        electronicLevyAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Account_Information (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        accountNumber VARCHAR(255) NOT NULL,
        accountProductCode VARCHAR(255) NOT NULL,
        branchCode VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        accountStatus VARCHAR(255) NOT NULL,
        orgAccountBalance DECIMAL(18, 2) NOT NULL,
        usdAccountBalance DECIMAL(18, 2) NOT NULL,
        tzsAccountBalance DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Personal_Data_Individuals (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        customerName VARCHAR(255) NOT NULL,
        customerType VARCHAR(255) NOT NULL, -- References Table D54
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        gender VARCHAR(255) NOT NULL, -- References Table D93
        dateOfBirth DATETIME NOT NULL,
        nationality VARCHAR(255) NOT NULL, -- References Country table
        nationalIdentificationNumber VARCHAR(255) NOT NULL,
        passportNumber VARCHAR(255),
        driversLicense VARCHAR(255),
        voterId VARCHAR(255),
        postalCode VARCHAR(255),
        region VARCHAR(255), -- References Region table
        district VARCHAR(255), -- References Region table
        ward VARCHAR(255), -- References Region table
        country VARCHAR(255) -- References Country table
    );

CREATE TABLE
    Personal_Data_Corporates (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        companyName VARCHAR(255) NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        customerType VARCHAR(255) NOT NULL, -- References Table D54
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        registrationNumber VARCHAR(255) NOT NULL,
        taxIdentificationNumber VARCHAR(255) NOT NULL,
        incorporationDate DATETIME NOT NULL,
        countryOfIncorporation VARCHAR(255) NOT NULL, -- References Country table
        postalCode VARCHAR(255),
        groupParentCode VARCHAR(255) NOT NULL,
        shareOwnedPercentage DECIMAL(18, 2),
        shareOwnedAmount DECIMAL(18, 2)
    );

CREATE TABLE
    Personal_Data_Trust (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        trustName VARCHAR(255) NOT NULL,
        customerType VARCHAR(255) NOT NULL, -- References Table D54
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        registrationNumber VARCHAR(255) NOT NULL,
        registrationDate DATETIME NOT NULL,
        countryOfRegistration VARCHAR(255) NOT NULL, -- References Country table
        trusteeName VARCHAR(255) NOT NULL,
        trusteeNationalId VARCHAR(255) NOT NULL,
        nationality VARCHAR(255) NOT NULL, -- References Country table
        mobileNumber VARCHAR(255) NOT NULL,
        appointmentDate DATETIME NOT NULL,
        terminationDate DATETIME
    );

CREATE TABLE
    Personal_Data_Non_Profit (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        registeredName VARCHAR(255) NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        customerType VARCHAR(255) NOT NULL, -- References Table D54
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        registrationNumber VARCHAR(255) NOT NULL,
        registrationDate DATETIME NOT NULL,
        countryOfRegistration VARCHAR(255) NOT NULL, -- References Country table
        boardMemberName VARCHAR(255) NOT NULL,
        boardMemberIdentificationNumber VARCHAR(255) NOT NULL,
        boardMemberGender VARCHAR(255) NOT NULL, -- References Table D03
        boardMemberAge INT NOT NULL,
        boardMemberAppointmentDate DATETIME NOT NULL
    );

CREATE TABLE
    Card_Records (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        bankCode VARCHAR(255) NOT NULL, -- References Bank list
        cardNumber VARCHAR(255) NOT NULL,
        binNumber VARCHAR(255) NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        cardType VARCHAR(255) NOT NULL, -- References Table D74
        cardCategory VARCHAR(255) NOT NULL, -- References Table D75
        cardStatus VARCHAR(255) NOT NULL, -- References Table D64
        cardScheme VARCHAR(255) NOT NULL, -- References Table D69
        acquiringPartner VARCHAR(255) NOT NULL, -- References Table D163
        cardExpireDate DATETIME
    );

CREATE TABLE
    Card_Product (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        binNumber VARCHAR(255) NOT NULL,
        binNumberStartDate DATETIME NOT NULL,
        binNumberEndDate DATETIME,
        cardSchemeName VARCHAR(255) NOT NULL, -- References Table D69
        cardIssuerCategory VARCHAR(255) NOT NULL, -- References Table D112
        cardIssuer VARCHAR(255) NOT NULL -- References BIC
    );

CREATE TABLE
    Card_Transaction (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        cardNumber VARCHAR(255) NOT NULL,
        binNumber VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D72
        transactionChannel VARCHAR(255) NOT NULL, -- References Table D72
        merchantName VARCHAR(255) NOT NULL,
        merchantCountry VARCHAR(255) NOT NULL, -- References Country table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgTransactionAmount DECIMAL(18, 2) NOT NULL,
        usdTransactionAmount DECIMAL(18, 2) NOT NULL,
        tzsTransactionAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Channel_Records (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        branchCode VARCHAR(255) NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        channelType VARCHAR(255) NOT NULL, -- References Table D72
        channelName VARCHAR(255) NOT NULL,
        channelStatus VARCHAR(255) NOT NULL, -- References Table D64
        subscriptionDate DATETIME NOT NULL,
        lastTransactionDate DATETIME,
        channelStatus VARCHAR(255) NOT NULL -- References Table D64
    );

CREATE TABLE
    Outgoing_Remittance (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionId VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        senderName VARCHAR(255) NOT NULL,
        senderCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        remittanceType VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        agentPrincipal VARCHAR(255) NOT NULL -- References Table D115
    );

CREATE TABLE
    Incoming_Remittance (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionId VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        senderName VARCHAR(255) NOT NULL,
        senderCountry VARCHAR(255) NOT NULL, -- References Country table
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        remittanceType VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        agentPrincipal VARCHAR(255) NOT NULL -- References Table D115
    );

CREATE TABLE
    Internet_Banking (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        accountNumber VARCHAR(255) NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D72
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        valueAddedTaxAmount DECIMAL(18, 2) NOT NULL,
        exciseDutyAmount DECIMAL(18, 2) NOT NULL,
        electronicLevyAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Mobile_Banking (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        accountNumber VARCHAR(255) NOT NULL,
        transactionType VARCHAR(255) NOT NULL, -- References Table D72
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        valueAddedTaxAmount DECIMAL(18, 2) NOT NULL,
        exciseDutyAmount DECIMAL(18, 2) NOT NULL,
        electronicLevyAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Foreign_Term_Debts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        clientIdentificationNumber VARCHAR(255) NOT NULL,
        borrowerName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        loanAccountNumber VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgSanctionedAmount DECIMAL(18, 2) NOT NULL,
        tzsSanctionedAmount DECIMAL(18, 2) NOT NULL,
        orgOutstandingAmount DECIMAL(18, 2) NOT NULL,
        tzsOutstandingAmount DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        assetClassificationType VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL,
        tzsArrearsPrincipalAmount DECIMAL(18, 2) NOT NULL,
        orgArrearsInterestAmount DECIMAL(18, 2) NOT NULL,
        tzsArrearsInterestAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Written_Off_Loans (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        accountNumber VARCHAR(255) NOT NULL,
        borrowerName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgSanctionedAmount DECIMAL(18, 2) NOT NULL,
        usdSanctionedAmount DECIMAL(18, 2) NOT NULL,
        tzsSanctionedAmount DECIMAL(18, 2) NOT NULL,
        orgOutstandingAmount DECIMAL(18, 2) NOT NULL,
        usdOutstandingAmount DECIMAL(18, 2) NOT NULL,
        tzsOutstandingAmount DECIMAL(18, 2) NOT NULL,
        writeOffDate DATETIME NOT NULL,
        writeOffAmount DECIMAL(18, 2) NOT NULL,
        recoveryAmount DECIMAL(18, 2) NOT NULL,
        assetClassificationType VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        collateralType VARCHAR(255) NOT NULL, -- References Table D42
        tzsCollateralValue DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        loanOfficer VARCHAR(255) NOT NULL,
        loanSupervisor VARCHAR(255) NOT NULL
    );

CREATE TABLE
    Employee_Records (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        branchCode VARCHAR(255) NOT NULL,
        empName VARCHAR(255) NOT NULL,
        gender VARCHAR(255) NOT NULL, -- References Table D93
        empId VARCHAR(255) NOT NULL,
        empNin VARCHAR(255) NOT NULL,
        empPosition VARCHAR(255) NOT NULL,
        empDepartment VARCHAR(255) NOT NULL,
        empAppointmentDate DATETIME NOT NULL,
        empTerminationDate DATETIME,
        lastPromotionDate DATETIME,
        basicSalary DECIMAL(18, 2) NOT NULL,
        empBenefits VARCHAR(255) NOT NULL
    );

CREATE TABLE
    Directors_Records (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        branchCode VARCHAR(255) NOT NULL,
        directorName VARCHAR(255) NOT NULL,
        directorDateOfBirth DATETIME NOT NULL,
        nationality VARCHAR(255) NOT NULL, -- References Country table
        gender VARCHAR(255) NOT NULL, -- References Table D93
        committeeMembership VARCHAR(255) NOT NULL,
        directorFees DECIMAL(18, 2) NOT NULL,
        directorAllowance DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    IFEM_Transactions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        marketType VARCHAR(255) NOT NULL,
        buyerBankName VARCHAR(255) NOT NULL, -- References Bank list
        sellerBankName VARCHAR(255) NOT NULL, -- References Bank list
        currency VARCHAR(255) NOT NULL, -- References Currency table
        exchangeRate DECIMAL(18, 2) NOT NULL,
        orgAmountBought DECIMAL(18, 2) NOT NULL,
        usdAmountBought DECIMAL(18, 2) NOT NULL,
        tzsAmountBought DECIMAL(18, 2) NOT NULL,
        tzsAmountOffered DECIMAL(18, 2) NOT NULL,
        orgAmountSold DECIMAL(18, 2) NOT NULL,
        usdAmountSold DECIMAL(18, 2) NOT NULL,
        tzsAmountSold DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    IFEM_Quotes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        bankCode VARCHAR(255) NOT NULL, -- References Bank list
        currency VARCHAR(255) NOT NULL, -- References Currency table
        tzsBidPrice DECIMAL(18, 2) NOT NULL,
        tzsAskPrice DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    IBCM_Transactions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        transactionDate DATETIME NOT NULL,
        lenderName VARCHAR(255) NOT NULL, -- References Bank list
        borrowerName VARCHAR(255) NOT NULL, -- References Bank list
        transactionType VARCHAR(255) NOT NULL, -- References Table D62
        tzsAmount DECIMAL(18, 2) NOT NULL,
        tenure INT NOT NULL,
        interestRate DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Secondary_TBond_Trading (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        tradeDate DATETIME NOT NULL,
        sellerName VARCHAR(255) NOT NULL,
        buyerName VARCHAR(255) NOT NULL,
        treasuryBondAuctionNumber VARCHAR(255) NOT NULL,
        treasuryBondIsinNumber VARCHAR(255) NOT NULL,
        issueDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        price DECIMAL(18, 2) NOT NULL,
        yield DECIMAL(18, 2) NOT NULL,
        couponRate DECIMAL(18, 2) NOT NULL,
        tenure VARCHAR(255) NOT NULL -- References Table D143
    );

-- api_endpoints_tables_bank_assurance.sql
CREATE TABLE
    Insurance_Underwriting (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        customerIdentificationNumber VARCHAR(255),
        bancassuranceId VARCHAR(255) NOT NULL,
        policyNumber VARCHAR(255) NOT NULL,
        clientName VARCHAR(255) NOT NULL,
        insurerName VARCHAR(255) NOT NULL, -- References Insurer list
        insurerStatus VARCHAR(255) NOT NULL, -- References Table D64
        clientCountry VARCHAR(255) NOT NULL, -- References Country table
        insuranceBusinessType VARCHAR(255) NOT NULL, -- References Table D125
        classBusiness VARCHAR(255) NOT NULL, -- References insurance business class
        subClassBusiness01 VARCHAR(255) NOT NULL, -- References insurance business class
        subClassBusiness02 VARCHAR(255) NOT NULL, -- References insurance business class
        insuranceProductName VARCHAR(255) NOT NULL,
        gender VARCHAR(255) NOT NULL, -- References Table D93
        disability VARCHAR(255),
        clientType VARCHAR(255) NOT NULL, -- References Table D54
        relatedParty VARCHAR(255) NOT NULL, -- References Table D55
        relationshipCategory VARCHAR(255) NOT NULL, -- References Table D95
        branchCode VARCHAR(255) NOT NULL,
        region VARCHAR(255) NOT NULL, -- References region table
        district VARCHAR(255) NOT NULL, -- References region table
        responsibleOfficer VARCHAR(255),
        responsibleSupervisor VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgSumInsuredAmount DECIMAL(18, 2) NOT NULL,
        tzsSumInsuredAmount DECIMAL(18, 2) NOT NULL,
        premiumRate DECIMAL(18, 2) NOT NULL,
        orgPremiumAmount DECIMAL(18, 2) NOT NULL,
        tzsPremiumAmount DECIMAL(18, 2) NOT NULL,
        frequencyPremium VARCHAR(255) NOT NULL, -- References Table D09
        policyStartDate DATETIME NOT NULL,
        policyMaturityDate DATETIME NOT NULL,
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        economicActivity VARCHAR(255) NOT NULL -- References economic Activity table
    );

CREATE TABLE
    Insurance_Commission (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        policyNumber VARCHAR(255) NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgCommissionReceivedAmount DECIMAL(18, 2) NOT NULL,
        tzsCommissionReceivedAmount DECIMAL(18, 2) NOT NULL,
        commissionReceivedDate DATETIME NOT NULL,
        commissionRate DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Complaints_And_Fraud_Statistics (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        policyNumber VARCHAR(255) NOT NULL,
        complaintNature VARCHAR(255) NOT NULL, -- References Table D127
        occurrenceDate DATETIME NOT NULL,
        complaintReportingDate DATETIME NOT NULL,
        closureDate DATETIME,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        tzsAmount DECIMAL(18, 2) NOT NULL,
        complaintStatus VARCHAR(255) NOT NULL, -- References Table D107
        complaintsReferred VARCHAR(255) NOT NULL -- References Table D57
    );

CREATE TABLE
    Insurance_Claim (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        policyNumber VARCHAR(255) NOT NULL,
        insurerStatus VARCHAR(255) NOT NULL, -- References Table D64
        claimRefNumber VARCHAR(255) NOT NULL,
        claimDate DATETIME NOT NULL,
        claimNature VARCHAR(255) NOT NULL,
        incidentOccurrenceDate DATETIME NOT NULL,
        incidentReportingDate DATETIME NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgSumClaimAmount DECIMAL(18, 2) NOT NULL,
        tzsSumClaimAmount DECIMAL(18, 2) NOT NULL,
        orgPaidClaimAmount DECIMAL(18, 2) NOT NULL,
        tzsPaidClaimAmount DECIMAL(18, 2) NOT NULL,
        claimStatus VARCHAR(255) NOT NULL, -- References Table 80
        repudiationReason VARCHAR(255) NOT NULL,
        claimClosureDate DATETIME NOT NULL
    );

-- api_endpoints_tables.sql
CREATE TABLE
    Outstanding_Letters_Of_Credit (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        lettersCreditType VARCHAR(255) NOT NULL, -- References Table D39
        collateralType VARCHAR(255) NOT NULL, -- References Table D42
        openingDate DATETIME NOT NULL,
        expireDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        holderName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D19
        bankRelationshipType VARCHAR(255) NOT NULL, -- References Table D33
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        customerRatingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255), -- References Table D67
        gradesUnratedCustomer VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        orgOutstandingMargDepAmount DECIMAL(18, 2),
        usdOutstandingMargDepAmount DECIMAL(18, 2),
        tzsOutstandingMargDepAmount DECIMAL(18, 2),
        pastDueDays INT NOT NULL,
        assetClassificationType VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL,
        lcClassification VARCHAR(255) NOT NULL, -- References Table D164
        bankRatingStatus TINYINT NOT NULL, -- boolean
        crRatingConfirmingBank VARCHAR(255), -- References Table D67
        gradesUnratedConfirmingBank VARCHAR(255) -- References Table D68
    );

CREATE TABLE
    Export_Letters_Of_Credit_Confirmed (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        openingDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        holderName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D19
        bankRelationshipType VARCHAR(255) NOT NULL, -- References Table D33
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterForeignBank VARCHAR(255), -- References Table D67
        gradesUnratedForeignBank VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        assetClassificationType VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL,
        lcClassification VARCHAR(255) NOT NULL -- References Table D164
    );

CREATE TABLE
    Inward_Bills_For_Collection (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        openingDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        holderName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterDrawerBank VARCHAR(255), -- References Table D67
        gradesUnratedDrawerBank VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        assetClassificationType VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Outstanding_Guarantees_And_Indemnities (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        openingDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        beneficiaryName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D19
        bankRelationshipType VARCHAR(255) NOT NULL, -- References Table D33
        guaranteeTypes VARCHAR(255) NOT NULL, -- References Table D40
        collateralTypes VARCHAR(255) NOT NULL, -- References Table D42
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        counterGuarantorName VARCHAR(255),
        counterGuarantorCountry VARCHAR(255), -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterGuarantor VARCHAR(255), -- References Table D67
        gradesUnratedCounterGuarantor VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        assetClassificationType VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Securities_Purchased_Under_Resale (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        sellerName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        sellerCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255), -- References Table D67
        gradesUnratedCustomer VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgPurchasedAmount DECIMAL(18, 2) NOT NULL,
        usdPurchasedAmount DECIMAL(18, 2) NOT NULL,
        tzsPurchasedAmount DECIMAL(18, 2) NOT NULL,
        orgResaleAmount DECIMAL(18, 2) NOT NULL,
        usdResaleAmount DECIMAL(18, 2) NOT NULL,
        tzsResaleAmount DECIMAL(18, 2) NOT NULL,
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Securities_Sold_Under_Repurchase (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        buyerName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        valueDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        buyerCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255), -- References Table D67
        gradesUnratedCustomer VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgSoldAmount DECIMAL(18, 2) NOT NULL,
        usdSoldAmount DECIMAL(18, 2) NOT NULL,
        tzsSoldAmount DECIMAL(18, 2) NOT NULL,
        orgRepurchaseAmount DECIMAL(18, 2) NOT NULL,
        usdRepurchaseAmount DECIMAL(18, 2) NOT NULL,
        tzsRepurchaseAmount DECIMAL(18, 2) NOT NULL,
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Outward_Bills_For_Collection (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        openingDate DATETIME NOT NULL,
        maturityDate DATETIME NOT NULL,
        holderName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        beneficiaryName VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterBorrower VARCHAR(255), -- References Table D67
        gradesUnratedBorrower VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        assetClassificationType VARCHAR(255) NOT NULL, -- References Table D32
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Forward_Exchange_Sold (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        counterpartName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        currencyA VARCHAR(255) NOT NULL, -- References Currency table
        currencyB VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountCurrencyA DECIMAL(18, 2) NOT NULL,
        exchangeRateCurrencyAB DECIMAL(18, 2) NOT NULL,
        orgAmountCurrencyB DECIMAL(18, 2) NOT NULL,
        tzsExchangeRateCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsExchangeRateCurrencyB DECIMAL(18, 2) NOT NULL,
        tzsAmountCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsAmountCurrencyB DECIMAL(18, 2) NOT NULL,
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL,
        counterpartCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255), -- References Table D67
        gradesUnratedCustomer VARCHAR(255), -- References Table D68
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Forward_Exchange_Bought (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        counterpartName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        currencyA VARCHAR(255) NOT NULL, -- References Currency table
        currencyB VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountCurrencyA DECIMAL(18, 2) NOT NULL,
        exchangeRateCurrencyAB DECIMAL(18, 2) NOT NULL,
        orgAmountCurrencyB DECIMAL(18, 2) NOT NULL,
        tzsExchangeRateCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsExchangeRateCurrencyB DECIMAL(18, 2) NOT NULL,
        tzsAmountCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsAmountCurrencyB DECIMAL(18, 2) NOT NULL,
        transactionDate DATETIME NOT NULL,
        valueDate DATETIME NOT NULL,
        counterpartCrRating VARCHAR(255) NOT NULL,
        transactionType VARCHAR(255) NOT NULL,
        counterpartCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterSeller VARCHAR(255), -- References Table D67
        gradesUnratedSeller VARCHAR(255), -- References Table D68
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Trust_And_Other_Fiduciary_Accounts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        depositDate DATETIME NOT NULL,
        beneficiaryName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        itemType VARCHAR(255) NOT NULL,
        beneficiaryCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255), -- References Table D67
        gradesUnratedCustomer VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2),
        tzsAmount DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Items_Held_For_Safekeeping (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        itemOwnerName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        itemType VARCHAR(255) NOT NULL,
        contractDate DATETIME NOT NULL,
        depositDate DATETIME NOT NULL,
        ownerCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255),
        gradesUnratedCustomer VARCHAR(255),
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2),
        tzsAmount DECIMAL(18, 2) NOT NULL,
        withdrawalDate DATETIME NOT NULL,
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Underwriting_Accounts_Unsold (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        securityIssuerName VARCHAR(255) NOT NULL,
        transactionDate DATETIME NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        underwrittenSecurityType VARCHAR(255) NOT NULL, -- References Table D27
        contractDate DATETIME NOT NULL,
        contractNumber VARCHAR(255) NOT NULL,
        issuerCountry VARCHAR(255) NOT NULL, -- References Country table
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255), -- References Table D67
        gradesUnratedCustomer VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgCommitmentAmount DECIMAL(18, 2) NOT NULL,
        usdCommitmentAmount DECIMAL(18, 2),
        tzsCommitmentAmount DECIMAL(18, 2) NOT NULL,
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Late_Deposits_Payments_Received (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        depositDate DATETIME NOT NULL,
        depositorName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255),
        gradesUnratedCustomer VARCHAR(255),
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgDepositedAmount DECIMAL(18, 2) NOT NULL,
        usdDepositedAmount DECIMAL(18, 2) NOT NULL,
        tzsDepositedAmount DECIMAL(18, 2) NOT NULL,
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Travelers_Cheques_Unsold (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        payeeName VARCHAR(255) NOT NULL,
        instrumentDate DATETIME NOT NULL,
        instrumentIssuerBank VARCHAR(255) NOT NULL,
        drawerName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255),
        gradesUnratedCustomer VARCHAR(255),
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL,
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Sector classification table
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Undrawn_Balances (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        customerIdentificationNumber VARCHAR(255) NOT NULL,
        borrowerName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        contractDate DATETIME NOT NULL,
        categoryUndrawnBalance VARCHAR(255) NOT NULL, -- References Table D41
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterCustomer VARCHAR(255) NOT NULL, -- References Table D67
        gradesUnratedCustomer VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgSanctionedAmount DECIMAL(18, 2) NOT NULL,
        usdSanctionedAmount DECIMAL(18, 2) NOT NULL,
        tzsSactionedAmount DECIMAL(18, 2) NOT NULL,
        orgDisbursedAmount DECIMAL(18, 2) NOT NULL,
        usdDisbursedAmount DECIMAL(18, 2) NOT NULL,
        tzsDisbursedAmount DECIMAL(18, 2) NOT NULL,
        orgUnutilisedAmount DECIMAL(18, 2) NOT NULL,
        usdUnutilisedAmount DECIMAL(18, 2) NOT NULL,
        tzsUnutilisedAmount DECIMAL(18, 2) NOT NULL,
        collateralType VARCHAR(255) NOT NULL, -- References Table D42
        pastDueDays INT NOT NULL,
        allowanceProbableLoss DECIMAL(18, 2) NOT NULL,
        botProvision DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Pre_Operating_Expenses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgAmount DECIMAL(18, 2) NOT NULL,
        usdAmount DECIMAL(18, 2) NOT NULL,
        tzsAmount DECIMAL(18, 2) NOT NULL
    );

CREATE TABLE
    Currency_Swap (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        contractDate DATETIME NOT NULL,
        contractNumber VARCHAR(255) NOT NULL,
        maturityDate DATETIME NOT NULL,
        counterpartName VARCHAR(255) NOT NULL,
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterPart VARCHAR(255),
        gradesUnratedCounterPart VARCHAR(255),
        currencyA VARCHAR(255) NOT NULL, -- References Currency table
        currencyB VARCHAR(255) NOT NULL, -- References Currency table
        orgAmountCurrencyA DECIMAL(18, 2) NOT NULL,
        spotExchangeRateCurrencyAB DECIMAL(18, 2) NOT NULL,
        orgAmountCurrencyB DECIMAL(18, 2) NOT NULL,
        tzsExchangeRateCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsExchangeRateCurrencyB DECIMAL(18, 2) NOT NULL,
        tzsAmountCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsAmountCurrencyB DECIMAL(18, 2) NOT NULL,
        fowardExchangeRate DECIMAL(18, 2) NOT NULL,
        tzsFowardExchangeRateCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsFowardExchangeRateCurrencyB DECIMAL(18, 2) NOT NULL,
        transactionDate DATETIME NOT NULL,
        tzsFowardCurrencyA DECIMAL(18, 2) NOT NULL,
        tzsFowardCurrencyB DECIMAL(18, 2) NOT NULL,
        valueDate DATETIME NOT NULL,
        transactionType VARCHAR(255) NOT NULL,
        sectorSnaClassification VARCHAR(255) NOT NULL -- References Economic sector table
    );

CREATE TABLE
    Interest_Rate_Swap (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        contractDate DATETIME NOT NULL,
        contractNumber VARCHAR(255) NOT NULL,
        maturityDate DATETIME NOT NULL,
        counterpartName VARCHAR(255) NOT NULL,
        counterpartCountry VARCHAR(255) NOT NULL, -- References Country table
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterpart VARCHAR(255),
        gradesUnratedCounterPart VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgContractAmount DECIMAL(18, 2) NOT NULL,
        tzsContractAmount DECIMAL(18, 2) NOT NULL,
        fixedInterestRate DECIMAL(18, 2) NOT NULL,
        floatInterestRate DECIMAL(18, 2) NOT NULL,
        liborRate DECIMAL(18, 2) NOT NULL,
        taxRate DECIMAL(18, 2) NOT NULL,
        arrangementFee DECIMAL(18, 2) NOT NULL,
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic sector table
        tradingIntent VARCHAR(255) NOT NULL -- References Table D90
    );

CREATE TABLE
    Equity_Derivatives (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        contractDate DATETIME NOT NULL,
        contractNumber VARCHAR(255) NOT NULL,
        maturityDate DATETIME NOT NULL,
        counterpartName VARCHAR(255) NOT NULL,
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterpart VARCHAR(255), -- References Table D67
        gradesUnratedCounterPart VARCHAR(255), -- References Table D68
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        equityDerivativesCategory VARCHAR(255) NOT NULL, -- References Table D79
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic sector table
        counterpartCountry VARCHAR(255) NOT NULL, -- References Country table
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgContractAmount DECIMAL(18, 2) NOT NULL,
        tzsContractAmount DECIMAL(18, 2) NOT NULL,
        fixedInterestRate DECIMAL(18, 2) NOT NULL,
        tzsStartStockPriceAmount DECIMAL(18, 2) NOT NULL,
        orgStockPriceAmount DECIMAL(18, 2) NOT NULL,
        tzsStockPriceAmount DECIMAL(18, 2) NOT NULL,
        tradingIntent VARCHAR(255) NOT NULL -- References Table D90
    );

CREATE TABLE
    Interest_Rate_Futures (
        id INT AUTO_INCREMENT PRIMARY KEY,
        reportingDate DATETIME NOT NULL,
        contractDate DATETIME NOT NULL,
        contractNumber VARCHAR(255) NOT NULL,
        expiryDate DATETIME NOT NULL,
        underlyingAssetType VARCHAR(255) NOT NULL,
        counterpartName VARCHAR(255) NOT NULL,
        counterpartCountry VARCHAR(255) NOT NULL, -- References Country table
        relationshipType VARCHAR(255) NOT NULL, -- References Table D33
        ratingStatus TINYINT NOT NULL, -- boolean
        crRatingCounterpart VARCHAR(255),
        gradesUnratedCounterPart VARCHAR(255), -- References Table D68
        currency VARCHAR(255) NOT NULL, -- References Currency table
        orgContractStartAmount DECIMAL(18, 2) NOT NULL,
        tzsContractStartAmount DECIMAL(18, 2) NOT NULL,
        orgContractCloseAmount DECIMAL(18, 2) NOT NULL,
        tzsContractCloseAmount DECIMAL(18, 2) NOT NULL,
        orgMarginAccStartAmount DECIMAL(18, 2) NOT NULL,
        tzsMarginAccStartAmount DECIMAL(18, 2) NOT NULL,
        orgMarginAccCloseAmount DECIMAL(18, 2) NOT NULL,
        tzsMarginAccCloseAmount DECIMAL(18, 2) NOT NULL,
        fixedInterestRate DECIMAL(18, 2) NOT NULL,
        floatInterestRate DECIMAL(18, 2) NOT NULL,
        liborRate DECIMAL(18, 2) NOT NULL,
        taxRate DECIMAL(18, 2) NOT NULL,
        arrangementFee DECIMAL(18, 2),
        sectorSnaClassification VARCHAR(255) NOT NULL, -- References Economic sector table
        tradingIntent VARCHAR(255) -- References Table D90
    );