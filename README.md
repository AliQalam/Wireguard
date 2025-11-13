<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>دليل إعداد WireGuard + WireGuard-UI</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
            background-color: #f4f4f4;
            color: #333;
        }
        h1, h2, h3 {
            color: #2c3e50;
        }
        code {
            background-color: #e1e1e1;
            padding: 2px 6px;
            border-radius: 4px;
            display: block;
            margin: 10px 0;
        }
        pre {
            background-color: #e1e1e1;
            padding: 10px;
            border-radius: 6px;
            overflow-x: auto;
        }
        section {
            background-color: #fff;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        a {
            color: #2980b9;
        }
        ul {
            margin-left: 20px;
        }
    </style>
</head>
<body>
    <section>
        <h1>دليل إعداد WireGuard + WireGuard-UI على Ubuntu</h1>
        <p>هذا المستند يشرح الخطوات التالية بعد تثبيت WireGuard وواجهة المستخدم WireGuard-UI على السيرفر، وتسجيل الدخول للوصول إلى الإعدادات النهائية.</p>
    </section>

    <section>
        <h2>الوصول إلى واجهة WireGuard-UI</h2>
        <ol>
            <li>افتح المتصفح وادخل على: <code>http://&lt;IP-SERVER&gt;:5000</code></li>
            <li>استبدل <code>&lt;IP-SERVER&gt;</code> بعنوان IP الخاص بسيرفرك.</li>
            <li>سجل الدخول باستخدام بيانات المستخدم وكلمة المرور التي تم تعيينها في ملف <code>docker-compose.yml</code>:
                <ul>
                    <li><strong>المستخدم:</strong> admin</li>
                    <li><strong>كلمة المرور:</strong> password (أو ما قمت بتحديده)</li>
                </ul>
            </li>
        </ol>
    </section>

    <section>
        <h2>الدخول إلى إعدادات WireGuard Server</h2>
        <ol>
            <li>بعد تسجيل الدخول، اذهب إلى القائمة الجانبية واختر <strong>WireGuard Server Settings</strong>.</li>
            <li>ستجد هناك خيارين رئيسيين لإضافة سكربتات <strong>Post Up</strong> و <strong>Post Down</strong>.</li>
        </ol>
    </section>

    <section>
        <h2>إعداد Post Up Script</h2>
        <p>سكربت <strong>Post Up</strong> يعمل تلقائيًا عند بدء تشغيل WireGuard ويقوم بتوجيه حركة المرور للسيرفر. الصق التالي في الحقل الخاص بـ <strong>Post Up Script</strong>:</p>
        <pre>
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
        </pre>
        <p><strong>وظيفة هذا السكربت:</strong></p>
        <ul>
            <li>السماح بمرور جميع الحزم الواردة من واجهة <code>wg0</code>.</li>
            <li>إعادة كتابة عناوين المصدر (NAT) لجميع الحزم الصادرة على واجهة <code>eth0</code>، بحيث يتمكن العملاء من الوصول للإنترنت من خلال السيرفر.</li>
        </ul>
    </section>

    <section>
        <h2>إعداد Post Down Script</h2>
        <p>سكربت <strong>Post Down</strong> يعمل تلقائيًا عند إيقاف WireGuard لإزالة القواعد السابقة. الصق التالي في الحقل الخاص بـ <strong>Post Down Script</strong>:</p>
        <pre>
iptables -D FORWARD -i wg0 -j ACCEPT
iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
        </pre>
        <p><strong>وظيفة هذا السكربت:</strong></p>
        <ul>
            <li>إزالة قواعد التوجيه عند إيقاف الخدمة لتجنب أي تعارضات مع إعدادات الشبكة الأخرى.</li>
        </ul>
    </section>

    <section>
        <h2>ملاحظات مهمة</h2>
        <ul>
            <li>تأكد من أن البورتات <code>5000</code> و <code>51820/UDP</code> مفتوحة على جدار الحماية الخاص بالسيرفر.</li>
            <li>يمكنك تعديل قواعد <code>iptables</code> لاحقًا حسب الحاجة للوصول إلى الشبكة الداخلية أو إضافة NAT إضافي.</li>
            <li>بعد أي تعديل في السكربتات، يمكنك إعادة تشغيل الحاويات لتطبيق التغييرات:
                <pre>sudo docker compose restart</pre>
            </li>
            <li>للتأكد من حالة الحاويات:
                <pre>sudo docker ps</pre>
            </li>
        </ul>
    </section>

    <section>
        <h2>روابط مفيدة</h2>
        <ul>
            <li><a href="https://www.wireguard.com/" target="_blank">WireGuard Documentation</a></li>
            <li><a href="https://github.com/ngoduykhanh/wireguard-ui" target="_blank">WireGuard-UI GitHub</a></li>
            <li><a href="https://docs.docker.com/" target="_blank">Docker Documentation</a></li>
        </ul>
    </section>

</body>
</html>
