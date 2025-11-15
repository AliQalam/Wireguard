<h1 align="center">🚀 WIREGUARD + WIREGUARD-UI – دليل شامل للإعداد على Ubuntu</h1>

<p align="center">
  <strong>💻 تثبيت مباشر:</strong> انسخ الأمر التالي والصقه في التيرمنال لتثبيت WireGuard تلقائيًا:
</p>

<pre><code>curl -sSL https://raw.githubusercontent.com/AliQalam/Wireguard/main/wireguard.sh | bash</code></pre>

<p align="center">
  <a href="https://github.com/AliQalam/Wireguard/blob/main/wireguard.sh" target="_blank">
    🔗 رابط السكربت على GitHub
  </a>
</p>

<hr>

<p align="center">
  هذا المشروع يشرح كيفية تثبيت وتشغيل WireGuard مع واجهة المستخدم الرسومية WireGuard-UI على سيرفر Ubuntu، مع إعداد سكربتات Post Up و Post Down لتوجيه حركة المرور بسهولة 💪
</p>

<hr>

<h2>🎯 أهداف الدليل</h2>

<ul>
  <li>🔐 تثبيت WireGuard بشكل آمن ومستقر</li>
  <li>🖥️ إدارة VPN بسهولة من خلال واجهة WireGuard-UI</li>
  <li>⚙️ إعداد قواعد Post Up و Post Down تلقائيًا</li>
  <li>🌐 ضمان مرور حركة الإنترنت للعملاء عبر VPN بشكل صحيح</li>
</ul>

<hr>

<h2>🛠️ خطوات الوصول إلى واجهة WireGuard-UI</h2>

<ol>
  <li>افتح المتصفح وادخل على: <code>http://&lt;IP-SERVER&gt;:5000</code></li>
  <li>استبدل <code>&lt;IP-SERVER&gt;</code> بعنوان IP الخاص بسيرفرك</li>
  <li>سجل الدخول باستخدام بيانات المستخدم وكلمة المرور الموجودة في ملف <code>docker-compose.yml</code>:
    <ul>
      <li><strong>المستخدم:</strong> admin</li>
      <li><strong>كلمة المرور:</strong> password (أو ما قمت بتحديده)</li>
    </ul>
  </li>
</ol>

<hr>

<h2>⚙️ إعداد سكربتات Post Up و Post Down</h2>

<p>بعد تسجيل الدخول:</p>
<ol>
  <li>اذهب إلى <strong>WireGuard Server Settings</strong></li>
  <li>الصق السكربت التالي في <strong>Post Up Script</strong>:</li>
</ol>

<pre><code>iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE</code></pre>

<p>وظيفة هذا السكربت:</p>
<ul>
  <li>السماح بمرور الحزم عبر واجهة <code>wg0</code></li>
  <li>إعادة كتابة عناوين المصدر لجميع الحزم الصادرة على واجهة <code>eth0</code></li>
</ul>

<ol start="3">
  <li>الصق السكربت التالي في <strong>Post Down Script</strong>:</li>
</ol>

<pre><code>iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE</code></pre>

<p>وظيفة هذا السكربت:</p>
<ul>
  <li>إزالة قواعد التوجيه عند إيقاف الخدمة لتجنب أي تعارضات</li>
</ul>

<hr>

<h2>💡 ملاحظات مهمة</h2>

<ul>
  <li>تأكد من أن البورتات <code>5000</code> و <code>51820/UDP</code> مفتوحة على جدار الحماية</li>
  <li>بعد أي تعديل، أعد تشغيل الحاويات لتنفيذ التغييرات:
    <pre><code>sudo docker compose restart</code></pre>
  </li>
  <li>للتحقق من حالة الحاويات:
    <pre><code>sudo docker ps</code></pre>
  </li>
</ul>

<hr>

<h2>🖼️ صور توضيحية</h2>

<div align="center">

<table style="border-collapse: separate; border-spacing: 20px;">
  <tr>
    <td align="center" style="background-color: #f0f8ff; padding: 15px; border-radius: 12px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
      <strong style="color: #007acc;">🔹 تسجيل الدخول</strong><br>
      <img src="images/login.png" width="250" style="border-radius: 10px;"/>
    </td>
    <td align="center" style="background-color: #fff0f5; padding: 15px; border-radius: 12px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
      <strong style="color: #cc3366;">🔹 الدخول إلى Server Settings</strong><br>
      <img src="images/server-settings.png" width="250" style="border-radius: 10px;"/>
    </td>
    <td align="center" style="background-color: #f5fff0; padding: 15px; border-radius: 12px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
      <strong style="color: #228b22;">🔹 إضافة Post Up / Post Down</strong><br>
      <img src="images/post-scripts.png" width="250" style="border-radius: 10px;"/>
    </td>
  </tr>
</table>

</div>

<hr>

<h2>📬 Join Our Telegram Community</h2>

<div align="center" style="margin-top: 20px;">
  <a href="https://t.me/star1ink_1raq" target="_blank">
    <img src="https://img.shields.io/badge/Join%20Us%20on-Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white" alt="Join Telegram Group" height="60" style="border-radius: 10px; box-shadow: 0 0 15px rgba(0,0,0,0.2);">
  </a>
</div>

<p align="center">
  💬 تابع التحديثات، اطرح الأسئلة، وشارك في تطوير دليل WireGuard معنا.
</p>
