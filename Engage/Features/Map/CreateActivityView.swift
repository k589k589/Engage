import SwiftUI
import MapKit

struct CreateActivityView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var category = "選擇類別"
    @State private var date = Date()
    
    let categories = ["健康", "社區", "運動", "藝術", "音樂"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("活動資訊")) {
                    TextField("活動名稱", text: $name)
                    
                    Picker("活動類別", selection: $category) {
                        Text("選擇類別").tag("選擇類別")
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    
                    DatePicker("開始時間", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("描述")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("位置")) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(EngageTheme.Colors.terracotta)
                        Text("台北 101 (目前位置)")
                            .foregroundStyle(EngageTheme.Colors.secondaryText)
                    }
                }
            }
            .navigationTitle("創建活動")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(EngageTheme.Colors.terracotta)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("發佈") {
                        // Create action
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundStyle(EngageTheme.Colors.terracotta)
                    .disabled(name.isEmpty || category == "選擇類別")
                }
            }
        }
    }
}
