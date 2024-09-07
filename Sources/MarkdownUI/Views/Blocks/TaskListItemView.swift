import SwiftUI
import _Parser

struct TaskListItemView: View {
  @Environment(\.theme.listItem) private var listItem
  @Environment(\.theme.taskListMarker) private var taskListMarker

  private let item: RawTaskListItem
    
    private var content: String {
        item.children.map {child in
            guard case .paragraph(let content) = child else { return "" }
            return content.map { inlineNode in
                guard case .text(let text) = inlineNode else { return "" }
                return text
            }.joined()
        }.joined()
    }

  init(item: RawTaskListItem) {
    self.item = item
  }

  var body: some View {
    self.listItem.makeBody(
      configuration: .init(
        label: .init(self.label),
        content: .init(blocks: item.children)
      )
    )
  }

  private var label: some View {
    Label {
      BlockSequence(self.item.children)
    } icon: {
        self.taskListMarker.makeBody(configuration: .init(isCompleted: self.item.isCompleted, content: self.content))
        .textStyleFont()
    }
  }
}
