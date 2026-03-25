import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: String?
    
    let categories = ["全部", "健康", "社區", "運動", "藝術", "音樂"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { cat in
                    Button {
                        if cat == "全部" {
                            selectedCategory = nil
                        } else {
                            selectedCategory = cat
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Text(cat)
                                .foregroundStyle(EngageTheme.Colors.charcoal)
                            Spacer()
                            if (cat == "全部" && selectedCategory == nil) || cat == selectedCategory {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(EngageTheme.Colors.terracotta)
                            }
                        }
                    }
                }
            }
            .navigationTitle("篩選活動")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { dismiss() }
                        .foregroundStyle(EngageTheme.Colors.terracotta)
                }
            }
        }
    }
}
