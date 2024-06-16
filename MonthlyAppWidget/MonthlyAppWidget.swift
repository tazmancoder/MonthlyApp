//
//  MonthlyAppWidget.swift
//  MonthlyAppWidget
//
//  Created by Mark Perryman on 6/13/24.
//

import WidgetKit
import SwiftUI
import AppIntents

// This is where the magic happens and how you tell your widget
// to creates its timeline (update) policy and get it data
struct Provider: AppIntentTimelineProvider {
	func placeholder(in context: Context) -> DayEntry {
		DayEntry(date: Date(), showFunFont: false)
	}
	
	func snapshot(for configuration: ChangeFontIntent, in context: Context) async -> DayEntry {
		return DayEntry(date: Date(), showFunFont: false)
	}
	
	func timeline(for configuration: ChangeFontIntent, in context: Context) async -> Timeline<DayEntry> {
		var entries: [DayEntry] = []
		
		let showFunFont = configuration.funFont
		// Generate a timeline consisting of seven entries a day apart, starting from the current date.
		let currentDate = Date()
		for dayOffset in 0 ..< 7 {
			let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
			let startOfDate = Calendar.current.startOfDay(for: entryDate)
			let entry = DayEntry(date: startOfDate, showFunFont: showFunFont)
			entries.append(entry)
		}
		
		return Timeline(entries: entries, policy: .atEnd)
	}
	
}

// This is the data for the widget
struct DayEntry: TimelineEntry {
    let date: Date
	let showFunFont: Bool
}


struct MonthlyAppWidgetEntryView : View {
	@Environment(\.showsWidgetContainerBackground) var showsBackground
	
    var entry: DayEntry
	var config: MonthConfig
	let funFont = "Chalkduster"
	
	init(entry: DayEntry) {
		self.entry = entry
		self.config = MonthConfig.determineConfig(from: entry.date)
	}
	
    var body: some View {
		VStack {
			HStack(spacing: 4) {
				// To find the emoji's hit
				// CMD-CTRL-SPC
				Text(config.emojiText)
					.font(.title)
				Text(entry.date.weekdayDisplayFormat)
					.font(entry.showFunFont ? .custom(funFont, size: 24) : .title3)
					.fontWeight(.bold)
					.minimumScaleFactor(0.6)
					.foregroundStyle(showsBackground ? config.weekdayTextColor : .white)
				Spacer()
			}
			.id(entry.date)
			.transition(.push(from: .trailing))
			.animation(.bouncy, value: entry.date)
			
			Text(entry.date.dayDisplayFormat)
				.font(entry.showFunFont ? .custom(funFont, size: 80) : .system(size: 80, weight: .heavy))
				.foregroundStyle(showsBackground ? config.dayTextColor : .white)
				.contentTransition(.numericText())
		}
		.containerBackground(for: .widget) {
			ContainerRelativeShape()
				.fill(config.backgroundColor.gradient)
		}
    }
}

struct MonthlyAppWidget: Widget {
    let kind: String = "MonthlyAppWidget"

    var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind, intent: ChangeFontIntent.self, provider: Provider()) { entry in
			MonthlyAppWidgetEntryView(entry: entry)
		}
		// This is the title user sees about your widget
		.configurationDisplayName("Monthly Style Widget")
		// This is the descrition the user will see
		.description("The theme of the widget changes based on the month.")
		// This is how you tell the system which sizes you support
		.supportedFamilies([.systemSmall])
		// This is how you tell the system where and what size to exclude the widget
		.disfavoredLocations([.standBy], for: [.systemSmall])
		
		// This is where you are not giving an intent
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//			MonthlyAppWidgetEntryView(entry: entry)
//        }
		// This is the title user sees about your widget
//        .configurationDisplayName("Monthly Style Widget")
		// This is the descrition the user will see
//        .description("The theme of the widget changes based on the month.")
		// This is how you tell the system which sizes you support
//		.supportedFamilies([.systemSmall])
		// This is how you tell the system where and what size to exclude the widget
//		.disfavoredLocations([.standBy], for: [.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    MonthlyAppWidget()
} timeline: {
	MockData.dayOne
	MockData.dayTwo
	MockData.dayThree
	MockData.dayFour
	MockData.dayFive
	MockData.daySix
	MockData.daySeven
	MockData.dayEight
	MockData.dayNine
	MockData.dayTen
	MockData.dayEleven
	MockData.dayTwelve
}

struct ChangeFontIntent: AppIntent, WidgetConfigurationIntent {
	static var title: LocalizedStringResource = "Fun Font"
	static var description: IntentDescription = .init(stringLiteral: "Switch to a fun font")
	
	@Parameter(title: "Fun Font")
	var funFont: Bool
	
	
}

struct MockData {
	static let dayOne = DayEntry(date: dateToDisplay(month: 1, day: 4), showFunFont: false)
	static let dayTwo = DayEntry(date: dateToDisplay(month: 2, day: 5), showFunFont: false)
	static let dayThree = DayEntry(date: dateToDisplay(month: 3, day: 6), showFunFont: false)
	static let dayFour = DayEntry(date: dateToDisplay(month: 4, day: 7), showFunFont: false)
	static let dayFive = DayEntry(date: dateToDisplay(month: 5, day: 8), showFunFont: false)
	static let daySix = DayEntry(date: dateToDisplay(month: 6, day: 9), showFunFont: false)
	static let daySeven = DayEntry(date: dateToDisplay(month: 7, day: 10), showFunFont: false)
	static let dayEight = DayEntry(date: dateToDisplay(month: 8, day: 11), showFunFont: false)
	static let dayNine = DayEntry(date: dateToDisplay(month: 9, day: 12), showFunFont: false)
	static let dayTen = DayEntry(date: dateToDisplay(month: 10, day: 22), showFunFont: false)
	static let dayEleven = DayEntry(date: dateToDisplay(month: 11, day: 25), showFunFont: false)
	static let dayTwelve = DayEntry(date: dateToDisplay(month: 12, day: 31), showFunFont: false)
	
	
	static func dateToDisplay(month: Int, day: Int) -> Date {
		let components = DateComponents(calendar: Calendar.current,
										year: 2024,
										month: month,
										day: day)
		
		return Calendar.current.date(from: components)!
	}
}
