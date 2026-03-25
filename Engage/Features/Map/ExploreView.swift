import SwiftUI
import MapKit

/// Discovery Map tab — interactive map with activity markers
/// and a bottom "Recommended for You" list.
struct ExploreView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    // Default context for mock data
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.0339, longitude: 121.5644), // Taipei 101 area
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    // State for navigation/modals
    @State private var searchText = ""
    @State private var selectedActivity: Activity?
    @State private var showActivityDetail = false

    // Mock activities
    let mockActivities = [
        Activity(id: "m1", name: "Daan Park Run", category: "健康", locationName: "Daan Forest Park", coordinate: CLLocationCoordinate2D(latitude: 25.0326, longitude: 121.5358), joined: 12, maxCapacity: 20, timeString: "Tomorrow 07:00 AM", description: "A healthy morning run starting at Daan Park."),
        Activity(id: "m2", name: "Tech Meetup", category: "社交", locationName: "Taipei 101", coordinate: CLLocationCoordinate2D(latitude: 25.0339, longitude: 121.5644), joined: 45, maxCapacity: 50, timeString: "Friday 19:00 PM", description: "A great networking event for tech enthusiasts."),
        Activity(id: "m3", name: "Language Exchange", category: "學習", locationName: "Zhongshan Cafe", coordinate: CLLocationCoordinate2D(latitude: 25.0531, longitude: 121.5204), joined: 8, maxCapacity: 15, timeString: "Saturday 14:00 PM", description: "Practice English and Mandarin.")
    ]
    
    var filteredActivities: [Activity] {
        if searchText.isEmpty {
            return mockActivities
        }
        return mockActivities.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.category.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ZStack(alignment: .top) {
            // 1. Full-screen Map
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: filteredActivities) { activity in
                MapAnnotation(coordinate: activity.coordinate) {
                    Button {
                        selectedActivity = activity
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: activity.category == "健康" ? "figure.mind.and.body" : "person.2.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(EngageTheme.Colors.terracotta)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .scaleEffect(selectedActivity?.id == activity.id ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedActivity?.id)
                            
                            Text(activity.name)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(EngageTheme.Colors.charcoal)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(.white.opacity(0.9))
                                .clipShape(Capsule())
                                .shadow(radius: 2)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestLocation()
            }
            .onChange(of: locationManager.userLocation?.latitude) { newLat in
                if let newLoc = locationManager.userLocation {
                    // Update camera position to user's location
                    withAnimation {
                        region = MKCoordinateRegion(
                            center: newLoc,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    }
                }
            }

            // 2. Top UI: Header + Search
            VStack(spacing: EngageTheme.Spacing.md) {
                // Blur bg for header
                VStack(spacing: EngageTheme.Spacing.sm) {
                    // Simple top header
                    HStack {
                        Text("Explore")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(EngageTheme.Colors.charcoal)
                        Spacer()
                        Button {
                            // Map settings / filter
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title3)
                                .foregroundColor(EngageTheme.Colors.charcoal)
                                .padding(10)
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
                        }
                    }
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for activities or locations...", text: $searchText)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                }
                .padding(.horizontal)
                .padding(.top, 50) // Safe area
                .padding(.bottom, 12)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                )
                
                Spacer()
            }
        }
        .sheet(item: $selectedActivity) { activity in
            // Activity detail bottom sheet
            VStack(alignment: .leading, spacing: 16) {
                Text(activity.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(EngageTheme.Colors.charcoal)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(EngageTheme.Colors.terracotta)
                    Text(activity.locationName)
                        .font(.subheadline)
                        .foregroundColor(EngageTheme.Colors.secondaryText)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(EngageTheme.Colors.terracotta)
                    Text(activity.timeString)
                        .font(.subheadline)
                        .foregroundColor(EngageTheme.Colors.secondaryText)
                }
                
                HStack {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(EngageTheme.Colors.terracotta)
                    Text("\(activity.joined)/\(activity.maxCapacity) 參加")
                        .font(.subheadline)
                        .foregroundColor(EngageTheme.Colors.secondaryText)
                }
                
                Spacer()
                
                Button {
                    // Join action
                } label: {
                    Text("Join Activity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(EngageTheme.Colors.terracotta)
                        .cornerRadius(12)
                }
            }
            .padding()
            .presentationDetents([.fraction(0.35)])
            .presentationDragIndicator(.visible)
        }
    }
}

// Temporary Activity Model for Map demo
struct Activity: Identifiable {
    let id: String
    let name: String
    let category: String
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let joined: Int
    let maxCapacity: Int
    let timeString: String
    let description: String
}
