from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.action_chains import ActionChains
import time

# Setup
path_driver = "E:/DONLOT/chromedriver-win64/chromedriver.exe"
service = Service(path_driver)
driver = webdriver.Chrome(service=service)

# Buka aplikasi
driver.get("http://localhost:49904/")  # sesuaikan port jika berubah
time.sleep(3)  # tunggu splash screen

actions = ActionChains(driver)

# Klik tombol 'cek mood kamu hari ini'
actions.move_by_offset(400, 300).click().perform()
print("✅ Klik tombol mood")
time.sleep(3)

# Klik tanggal aktif di kalender (misal 6 Juni)
actions.move_by_offset(280, 200).click().perform()
print("✅ Klik tanggal")
time.sleep(2)

# Scroll ke bawah agar emoji dan jurnal muncul
driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
time.sleep(2)

# Klik emoji mood (kira-kira posisinya)
actions.move_by_offset(300, 350).click().perform()
print("✅ Klik emoji")
time.sleep(1)

# Klik kolom jurnal dan isi (jika bisa)
actions.move_by_offset(0, 100).click().perform()
actions.send_keys("Hari ini bahagia dan produktif.").perform()
print("✅ Isi jurnal")
time.sleep(1)

# Klik tombol simpan
actions.move_by_offset(0, 100).click().perform()
print("✅ Klik simpan")
time.sleep(2)

# Verifikasi muncul data
driver.execute_script("window.scrollTo(0, 0)")
print("✅ Proses selesai")
driver.quit()
