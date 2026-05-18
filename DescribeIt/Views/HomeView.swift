import SwiftUI

struct HomeView: View {
    @State private var selected: Animal?

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(AnimalLibrary.all) { animal in
                            AnimalCard(animal: animal) {
                                selected = animal
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .background(
                LinearGradient(colors: [Color(.systemBackground), Color.blue.opacity(0.06)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .navigationDestination(item: $selected) { animal in
                SessionView(animal: animal)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text("Describe It!")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
            Text("Pick an animal to describe!")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 24)
    }
}

private struct AnimalCard: View {
    let animal: Animal
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(animal.emoji)
                    .font(.system(size: 72))
                Text(animal.name)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
