<div align="center">

<img src="Screenshots/icon-app.png" width="100">

# 🌱 Planto

### Never forget to water your plants again

A plant care reminder app built with **SwiftUI** and **MVVM**.

![Platform](https://img.shields.io/badge/Platform-iOS-black?style=for-the-badge&logo=apple)
![SwiftUI](https://img.shields.io/badge/SwiftUI-orange?style=for-the-badge&logo=swift)
![MVVM](https://img.shields.io/badge/Architecture-MVVM-2F7360?style=for-the-badge)

</div>

---

## 📱 Screenshots

<div align="center">

| Onboarding | No Reminders | Add Plant |
|:---:|:---:|:---:|
| <img src="Screenshots/Onboarding.png" width="220"> | <img src="Screenshots/Empty State.png" width="220"> | <img src="Screenshots/Add Plant.png" width="220"> |

| My Plants | All Done | Notification |
|:---:|:---:|:---:|
| <img src="Screenshots/My Plants.png" width="220"> | <img src="Screenshots/All Done.png" width="220"> | <img src="Screenshots/Notification.png" width="220"> |

</div>

## 🚀 Features

- 🌿 Add, edit, and delete plants (room, light, water amount, watering days)
- ✅ Check plants off and track daily progress with a live progress bar
- ⬇️ Watered plants move below pending ones
- 🎉 "All Done" state when every plant is watered
- 👆 Swipe to delete
- 🔔 Local notifications scheduled by watering interval

## 🏗 Architecture (MVVM)

```
Planto
├── Models        → Plant
├── ViewModels    → PlantsViewModel, NotificationManager
├── Views         → OnboardingView, PlantsListView, PlantRow, SetReminderView
└── Extensions    → Color+Plant
```

## 🔮 Next Steps

- Re-schedule notifications when the app opens

## ▶️ Run

1. Clone: `git clone https://github.com/ILLH44/Planto.git
2. Open `Planto.xcodeproj`
3. Run on an iPhone simulator (⌘R)

## 👩‍💻 Author

**Hanen Alharbi**
