fs = require('fs')
path = require('path')
natural = require('natural')
Excel = require('exceljs')

classifier = new natural.BayesClassifier()

workbook = new Excel.Workbook()
workbook.csv.readFile('data.csv').then((worksheet) ->
    worksheet.eachRow((row, rowNumber) ->
        if rowNumber != 0
            label = if row.values[2] is 1 then 'pos' else 'neg'
            content = row.values[4]
            classifier.addDocument(content, label)
            console.log("Added " + rowNumber + " with label " + label)
    )
    console.log("Training classifier...") ;
    classifier.train()
    console.log("Training successful.") ;

    classifier.save('./bin/classifier.json', (err, classifier) ->
        console.log(err) if err;
    )
)
