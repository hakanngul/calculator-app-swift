//
//  ViewController.swift
//  calculator-app
//
//  Created by Hakan GÜL on 20.04.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
        

    private var currentValue: String = "0"
    private var previousValue: Double = 0
    private var currentOperation: OperationType? = nil
    private var isNewInput = true
    private var displayExpression: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
    }
    
    private func updateDisplay() {
        if displayExpression.isEmpty {
            resultLabel.text = currentValue
        } else {
            resultLabel.text = displayExpression
        }
    }
    
    private func getOperationSymbol(_ operation: OperationType) -> String {
        switch operation {
        case .addition: return " + "
        case .subtraction: return " - "
        case .multiplication: return " × "
        case .division: return " ÷ "
        }
    }
    
    private func formatResult(_ result: Double) -> String {
        return result.truncatingRemainder(dividingBy: 1) == 0 ?
            String(Int(result)) :
            String(format: "%.2f", result)
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let buttonTag = sender.tag
        
        if isNewInput || currentValue == "0" {
            currentValue = String(buttonTag)
            isNewInput = false
        } else {
            currentValue += String(buttonTag)
        }
        
        if displayExpression.contains("=") {
            // Yeni bir işleme başlıyoruz
            displayExpression = ""
        }
        
        // Bu satırları ekleyin:
        if currentOperation != nil && !displayExpression.isEmpty {
            // Ekranın güncel sayıyı göstermesini sağla
            resultLabel.text = currentValue
            return
        }
        
        updateDisplay()
    }
    

    @IBAction func comaButton(_ sender: UIButton) {
        if isNewInput {
            currentValue = "0."
            isNewInput = false
        } else if !currentValue.contains(".") {
            currentValue += "."
        }
        
        if displayExpression.contains("=") {
            displayExpression = ""
        }
        
        updateDisplay()
    }
   
    @IBAction func operationPressed(_ sender: UIButton) {
        let operationTag = sender.tag
        
        if currentOperation != nil && !isNewInput {
            let currentVal = Double(currentValue) ?? 0
            var result: Double = 0
            
            switch currentOperation! {
            case .addition:
                result = previousValue + currentVal
            case .subtraction:
                result = previousValue - currentVal
            case .multiplication:
                result = previousValue * currentVal
            case .division:
                if currentVal == 0 {
                    let alert = UIAlertController(
                        title: "Hata",
                        message: "Sıfıra bölme işlemi gerçekleştirilemez",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }
                result = previousValue / currentVal
            }
            
            // İşlem ifadesini güncelle
            displayExpression = displayExpression + currentValue + " = " + formatResult(result)
            currentValue = formatResult(result)
            updateDisplay()
            previousValue = result
            displayExpression = currentValue
        } else {
            previousValue = Double(currentValue) ?? 0
            displayExpression = currentValue
        }
        
        if let operation = OperationType(rawValue: operationTag) {
            currentOperation = operation
            displayExpression += getOperationSymbol(operation)
        } else {
            print("Geçersiz işlem kodu!")
        }
        
        updateDisplay()
        isNewInput = true
    }
    
    @IBAction func equalButton(_ sender: UIButton) {
        guard let operation = currentOperation else {
            return
        }
        
        if displayExpression.contains("=") {
            return
        }
        
        let currentVal = Double(currentValue) ?? 0
        var result: Double = 0
        
        switch operation {
        case .addition:
            result = previousValue + currentVal
        case .subtraction:
            result = previousValue - currentVal
        case .multiplication:
            result = previousValue * currentVal
        case .division:
            if currentVal == 0 {
                let alert = UIAlertController(
                    title: "Hata",
                    message: "Sıfıra bölme işlemi gerçekleştirilemez",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            result = previousValue / currentVal
        }
        
        displayExpression = displayExpression + currentValue + " = " + formatResult(result)
        currentValue = formatResult(result)
        updateDisplay()
        currentOperation = nil
        isNewInput = true
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        currentValue = "0"
        previousValue = 0
        currentOperation = nil
        isNewInput = true
        displayExpression = ""
        updateDisplay()
    }
    
    @IBAction func percentButton(_ sender: UIButton) {
        let currentVal = Double(currentValue) ?? 0
        currentValue = formatResult(currentVal / 100)
        
        if !displayExpression.isEmpty && !displayExpression.contains("=") {
            displayExpression = displayExpression.split(separator: " ").dropLast().joined(separator: " ") + " " + currentValue
        } else {
            displayExpression = currentValue
        }
        
        updateDisplay()
    }
    
@IBAction func signChangeButton(_ sender: UIButton) {
    let currentVal = Double(currentValue) ?? 0
    currentValue = formatResult(currentVal * -1)
    
    if !displayExpression.isEmpty && !displayExpression.contains("=") {
        displayExpression = displayExpression.split(separator: " ").dropLast().joined(separator: " ") + " " + currentValue
    } else {
        displayExpression = currentValue
    }
    
    updateDisplay()
    }
}
