
# 📊 MetricStream

**MetricStream** is a two-part application consisting of:

-   **MetricStream Agent** (Windows) - A background system monitoring tool.
-   **MetricStream Mobile App** (Android) - A real-time visualization app.

These applications work together over **WebSocket** to visualize real-time system load data, including **CPU usage, CPU frequency, RAM usage, and disk space**.

## 🚀 Features

-   📡 **WebSocket Communication** - Efficient real-time data transfer.
-   📈 **Live Monitoring**
    -   **CPU**: Usage (%) and frequency (MHz).
    -   **RAM**: Usage (%) and total/free memory (GB).
    -   **Disk**: Free and used space (%).
-   📊 **Graphical Visualization**
    -   **CPU & RAM**: Line charts for trends.
    -   **Disk Usage**: Pie chart for clear insights.
-   ⚡ **Lightweight and Fast**
    -   Runs in the background with minimal system impact.

## 📥 Installation

### 🖥️ Windows (Agent)

1.  Download **MetricStreamAgent.exe** from the latest release.
2.  Run the executable; it will start as a system tray application.
3.  The agent automatically starts a WebSocket server for real-time data streaming.

### 📱 Android (Mobile App)

1.  Download and install **MetricStream.apk**.
2.  Enter the **PC's IP address** to connect to the WebSocket server.
3.  View real-time system metrics on your phone!

## 🛠️ Usage

1.  **Run the Agent** on your PC (Windows).
2.  **Start the Mobile App** and connect via WebSocket.
3.  Monitor system performance in real time with dynamic charts!

## ⚙️ Configuration

-   Ensure your **PC and mobile device** are on the **same network**.
-   The WebSocket server runs on `ws://<PC-IP>:36500`.
-   Firewall exceptions may be needed for connectivity.
