import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:frontend/viewModel/create_entreprise.dart';
import 'tableau_bord_entreprise.dart';

// Dans _RegisterPageState, ajoute :
Uint8List? _logoBytes;
final ImagePicker _picker = ImagePicker();
// ─── Couleurs globales ───────────────────────────────────────────────────────
const kBlue = Color(0xFF1A6EF5);
const kBlueLight = Color(0xFFE8F0FE);
const kBlueMid = Color(0xFF4285F4);
const kGrey100 = Color(0xFFF3F4F6);
const kGrey200 = Color(0xFFE5E7EB);
const kGrey400 = Color(0xFF9CA3AF);
const kGrey600 = Color(0xFF6B7280);
const kGrey900 = Color(0xFF111827);

// ─── Page principale ────────────────────────────────────────────────────────
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final ViewModelCreateEntreprise _viewModel =
    ViewModelCreateEntreprise();


  int _currentStep = 0;

  // Données formulaire étape 1
  final _nomCtrl = TextEditingController();
  String _secteur = '';
  final _villeCtrl = TextEditingController();
  String _taille = '';

  // Données formulaire étape 2
  final _nomPdgCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _pw2Ctrl = TextEditingController();
  final _telCtrl = TextEditingController();
  bool _showPw = false;
  bool _showPw2 = false;
  

  // Données étape 3
  final List<Map<String, String>> _services = [];
  final _svcNomCtrl = TextEditingController();
  final _svcRespCtrl = TextEditingController();
  bool _showQuickAdd = false;

  @override
  void initState() {
    super.initState();
    _pwCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _villeCtrl.dispose();
    _nomPdgCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    _telCtrl.dispose();
    _svcNomCtrl.dispose();
    _svcRespCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < 3) setState(() => _currentStep++);
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  int _passwordStrength(String pw) {
    int score = 0;
    if (pw.length >= 8) score++;
    if (pw.contains(RegExp(r'[A-Z]'))) score++;
    if (pw.contains(RegExp(r'[0-9]'))) score++;
    if (pw.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    return score;
  }

  Color _pwColor(int s) {
    switch (s) {
      case 1: return Colors.red;
      case 2: return Colors.orange;
      case 3: return Colors.blue;
      case 4: return Colors.green;
      default: return kGrey200;
    }
  }

  String _pwLabel(int s) {
    switch (s) {
      case 1: return 'Faible';
      case 2: return 'Moyen';
      case 3: return 'Bon';
      case 4: return 'Fort';
      default: return '';
    }
  }

  // InputDecoration uniforme pour tous les champs
  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 14, color: kGrey400),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kBlue, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Row(
          children: [
            // ───────── MENU GAUCHE ─────────
            Container(
              width: 280,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: kGrey200, width: 0.8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  Expanded(child: _buildStepNav()),
                ],
              ),
            ),

            // ───────── CONTENU DROITE ─────────
            Expanded(
              child: Container(
                color: const Color(0xFFF9FAFB),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(_currentStep),
                      child: _buildStep(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Barre supérieure ──────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kGrey200, width: 0.8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('A',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
          ),
          const SizedBox(width: 10),
          const Text('Avia',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kGrey900,
                  letterSpacing: -0.3)),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: RichText(
              text: const TextSpan(
                text: 'Déjà inscrit ? ',
                style: TextStyle(fontSize: 12, color: kGrey600),
                children: [
                  TextSpan(
                    text: 'Se connecter',
                    style: TextStyle(color: kBlue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Navigation des étapes ────────────────────────────────────────────────
  Widget _buildStepNav() {
    final steps = [
      'Votre entreprise',
      'Compte PDG',
      'Services internes',
      'Confirmation',
    ];
    final descs = [
      'Infos générales',
      'Email & mot de passe',
      'Départements & équipes',
      'Vérification email',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (i) {
          final isActive = i == _currentStep;
          final isDone = i < _currentStep;

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _currentStep = i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: isActive ? kBlueLight : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Cercle numéro / check
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isActive || isDone) ? kBlue : kGrey200,
                    ),
                    alignment: Alignment.center,
                    child: isDone
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : kGrey600,
                            ),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i],
                        style: TextStyle(
                          fontSize: 13,
                          color: isActive ? kBlue : (isDone ? kGrey900 : kGrey600),
                          fontWeight: (isActive || isDone)
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      Text(
                        descs[i],
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive ? kBlueMid : kGrey400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Dispatch des étapes ──────────────────────────────────────────────────
  Widget _buildStep() {
    switch (_currentStep) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      case 3: return _buildStep4();
      default: return const SizedBox();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ÉTAPE 1 — Informations de l'entreprise
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildStep1() {
    final secteurs = [
      'Banque & Finance',
      'Industrie',
      'Commerce & Distribution',
      'Santé',
      'Éducation',
      'Technologie',
      'Transport & Logistique',
      'Autre',
    ];

    return _FormCard(
      title: 'Informations de l\'entreprise',
      subtitle:
          'Ces informations définiront l\'espace de travail de toute votre équipe.',
      stepLabel: 'Étape 1/4',
      onNext: _next,
      nextLabel: 'Suivant — Créer votre compte PDG',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Nom de l\'entreprise *'),
          TextField(
            controller: _nomCtrl,
            decoration: _inputDeco('Ex : Société Kongo SA'),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Secteur d\'activité *'),
                    DropdownButtonFormField<String>(
                      value: _secteur.isEmpty ? null : _secteur,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Choisir un secteur...',
                        hintStyle: const TextStyle(fontSize: 14, color: kGrey400),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 0.8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: kBlue, width: 1.5),
                        ),
                      ),
                      items: secteurs
                          .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s,
                                  style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (v) => setState(() => _secteur = v ?? ''),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Pays / Ville *'),
                    TextField(
                      controller: _villeCtrl,
                      decoration: _inputDeco('Ex : Brazzaville, Congo'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FieldLabel('Taille de l\'entreprise *'),
          const SizedBox(height: 6),
          Row(
            children: [
              _SizeOption(
                  label: 'PME',
                  desc: '1–50 emp.',
                  selected: _taille == 'PME',
                  onTap: () => setState(() => _taille = 'PME')),
              const SizedBox(width: 10),
              _SizeOption(
                  label: 'Moyenne',
                  desc: '50–250 emp.',
                  selected: _taille == 'Moyenne',
                  onTap: () => setState(() => _taille = 'Moyenne')),
              const SizedBox(width: 10),
              _SizeOption(
                  label: 'Grande',
                  desc: '250+ emp.',
                  selected: _taille == 'Grande',
                  onTap: () => setState(() => _taille = 'Grande')),
            ],
          ),
          const SizedBox(height: 14),
          _FieldLabel('Logo de l\'entreprise (optionnel)'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final XFile? picked = await _picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 512,
                maxHeight: 512,
              );
              if (picked != null) {

                final bytes = await picked.readAsBytes();

                setState(() {
                  _logoBytes = bytes;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGrey400, width: 1),
              ),
              child: _logoBytes != null
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(_logoBytes!,
                              height: 80, width: 80, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 8),
                        const Text('Appuyer pour changer',
                            style: TextStyle(fontSize: 12, color: kGrey400)),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: kBlueLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.upload_outlined, color: kBlue, size: 22),
                        ),
                        const SizedBox(height: 8),
                        const Text('Glisser-déposer ou cliquer',
                            style: TextStyle(fontSize: 13, color: kGrey900, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        const Text('PNG, JPG max 2 Mo',
                            style: TextStyle(fontSize: 12, color: kGrey400)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ÉTAPE 2 — Compte PDG
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildStep2() {
    final pwStrength = _passwordStrength(_pwCtrl.text);

    return _FormCard(
      title: 'Votre compte administrateur',
      subtitle:
          'Ce compte sera celui du PDG — il a accès à toutes les fonctionnalités.',
      stepLabel: 'Étape 2/4',
      onNext: _next,
      onBack: _back,
      nextLabel: 'Suivant — Définir les services',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recap bar
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: kBlueLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                _RecapChip('Entreprise',
                    _nomCtrl.text.isEmpty ? '—' : _nomCtrl.text),
                _RecapChip('Taille', _taille.isEmpty ? '—' : _taille),
                _RecapChip('Localisation',
                    _villeCtrl.text.isEmpty ? '—' : _villeCtrl.text),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Nom du PDG *'),
                    TextField(
                      controller: _nomPdgCtrl,
                      decoration: _inputDeco('Ex : Dupont'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Prénom *'),
                    TextField(
                      controller: _prenomCtrl,
                      decoration: _inputDeco('Ex : Jean'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FieldLabel('Email professionnel *'),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDeco('pdg@societe-kongo.com'),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Mot de passe *'),
                    TextField(
                      controller: _pwCtrl,
                      obscureText: !_showPw,
                      decoration: _inputDeco('••••••••').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                              _showPw
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: kGrey400),
                          onPressed: () =>
                              setState(() => _showPw = !_showPw),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 4 segments discrets
                    Row(
                      children: List.generate(4, (i) => Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: (_pwCtrl.text.isNotEmpty && i < pwStrength)
                                ? _pwColor(pwStrength)
                                : kGrey200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )),
                    ),
                    if (_pwCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _pwLabel(pwStrength),
                        style: TextStyle(
                            fontSize: 12,
                            color: _pwColor(pwStrength),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Confirmer le mot de passe *'),
                    TextField(
                      controller: _pw2Ctrl,
                      obscureText: !_showPw2,
                      decoration: _inputDeco('••••••••').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                              _showPw2
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: kGrey400),
                          onPressed: () =>
                              setState(() => _showPw2 = !_showPw2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FieldLabel('Téléphone (optionnel)'),
          TextField(
            controller: _telCtrl,
            keyboardType: TextInputType.phone,
            decoration: _inputDeco('+242 06 000 00 00'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ÉTAPE 3 — Services internes
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildStep3() {
    return _FormCard(
      title: 'Vos services et départements',
      subtitle:
          'Définissez les services de votre entreprise. Vous pourrez en ajouter d\'autres après.',
      stepLabel: 'Étape 3/4',
      onNext: _next,
      onBack: _back,
      nextLabel: 'Terminer la configuration',
      nextIcon: Icons.check,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message si aucun service
          if (_services.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: kGrey100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGrey200, width: 0.8),
              ),
              child: const Column(
                children: [
                  Icon(Icons.inbox_outlined, color: kGrey400, size: 28),
                  SizedBox(height: 6),
                  Text(
                    'Aucun service ajouté',
                    style: TextStyle(
                        fontSize: 13,
                        color: kGrey600,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Utilisez le bouton ci-dessous pour ajouter vos départements.',
                    style: TextStyle(fontSize: 11, color: kGrey400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

          // Liste des services saisis
          ..._services.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGrey200, width: 0.8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBlueLight,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                          color: kBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['nom']!,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kGrey900)),
                        if ((s['resp'] ?? '').isNotEmpty)
                          Text(
                            'Responsable : ${s['resp']}',
                            style: const TextStyle(
                                fontSize: 12, color: kGrey600),
                          ),
                      ],
                    ),
                  ),
                  // Bouton Éditer
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: kGrey200, width: 0.8),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: const Text('Éditer',
                          style:
                              TextStyle(fontSize: 12, color: kGrey600)),
                    ),
                  ),
                  // Bouton Retirer
                  GestureDetector(
                    onTap: () =>
                        setState(() => _services.removeAt(i)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.red.shade200, width: 0.8),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: Text('Retirer',
                          style: TextStyle(
                              fontSize: 12, color: Colors.red.shade400)),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          // Bouton ajouter
          GestureDetector(
            onTap: () =>
                setState(() => _showQuickAdd = !_showQuickAdd),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kGrey200, width: 0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: kBlue, size: 18),
                  SizedBox(width: 8),
                  Text('Ajouter un service',
                      style: TextStyle(fontSize: 13, color: kBlue)),
                ],
              ),
            ),
          ),

          // Formulaire d'ajout rapide
          if (_showQuickAdd) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kGrey100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGrey200, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ajout rapide d\'un service',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kGrey600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Nom du service *'),
                            TextField(
                              controller: _svcNomCtrl,
                              decoration: _inputDeco('Ex : Marketing'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Responsable (optionnel)'),
                            TextField(
                              controller: _svcRespCtrl,

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Entrer un employé...',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10)),
                          textStyle:
                              const TextStyle(fontSize: 13),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Ajouter'),
                        onPressed: () {
                          final nom = _svcNomCtrl.text.trim();
                          if (nom.isEmpty) return;
                          setState(() {
                            _services.add({
                              'nom': nom,
                              'resp': _svcRespCtrl.text.trim().isEmpty
                                  ? 'Responsable à définir'
                                  : _svcRespCtrl.text.trim(),
                            });
                            _svcNomCtrl.clear();
                            _svcRespCtrl.clear();
                            _showQuickAdd = false;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () =>
                            setState(() => _showQuickAdd = false),
                        child: const Text('Annuler',
                            style: TextStyle(color: kGrey600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ÉTAPE 4 — Confirmation
  // ═══════════════════════════════════════════════════════════════════════════
Widget _buildStep4() {

  final email = _emailCtrl.text.trim();
  final nomEntreprise = _nomCtrl.text.trim();
  final prenomPdg = _prenomCtrl.text.trim();
  final nomPdg = _nomPdgCtrl.text.trim();

  final localisation = _villeCtrl.text.trim();
  final secteur = _secteur;
  final tel = _telCtrl.text.trim();

  final tailleEntreprise = _taille;

  final pwdPDG = _pwCtrl.text.trim();
  final confirPwdPDG = _pw2Ctrl.text.trim();

  final logoEntreprise = _logoBytes;

  final nbServices = _services.length;

  final servicesNoms =
      _services.map((s) => s['nom']!).join(', ');

  final pdgName = '$prenomPdg $nomPdg'.trim();
  
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGrey200, width: 0.8),
      ),
      child: Column(
        children: [
          // Icône succès
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade100, width: 1),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.check_circle_outline,
                color: Colors.green.shade600, size: 36),
          ),
          const SizedBox(height: 14),
          const Text(
            'Entreprise créée avec succès !',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kGrey900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            email.isNotEmpty
                ? 'Un email de vérification a été envoyé à $email'
                : 'Vérifiez votre boîte mail pour activer votre compte.',
            style: const TextStyle(fontSize: 13, color: kGrey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Récapitulatif — format condensé comme le PDF
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kGrey200, width: 0.8),
            ),
            child: Column(
              children: [
                _RecapRow(
                  'Entreprise',
                  nomEntreprise.isNotEmpty ? nomEntreprise : '—',
                ),
                _RecapRow(
                  'PDG',
                  pdgName.isNotEmpty
                      ? '$pdgName${email.isNotEmpty ? ' — $email' : ''}'
                      : '—',
                ),
                _RecapRow(
                  'Taille',
                  _taille.isNotEmpty
                      ? '$_taille${_taille == 'PME' ? ' (1–50 employés)' : _taille == 'Moyenne' ? ' (50–250 employés)' : ' (250+ employés)'}'
                      : '—',
                ),
                if (secteur.isNotEmpty) _RecapRow('Secteur', secteur),
                if (localisation.isNotEmpty)
                  _RecapRow('Localisation', localisation),
                if (tel.isNotEmpty) _RecapRow('Téléphone', tel),
                _RecapRow(
                  'Services créés',
                  nbServices == 0
                      ? 'Aucun service ajouté'
                      : servicesNoms.isNotEmpty
                          ? '$servicesNoms ($nbServices service${nbServices > 1 ? 's' : ''})'
                          : '$nbServices service${nbServices > 1 ? 's' : ''}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Badge statut — "Vérification requise" comme le PDF
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.orange.shade200, width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time,
                    size: 14, color: Colors.orange.shade700),
                const SizedBox(width: 6),
                Text(
                  'En attente de vérification email',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Vérification requise',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Cliquez sur le lien dans l\'email pour activer votre espace Avia.\nLes employés ne pourront pas se connecter avant cette activation.',
              style: TextStyle(
                  fontSize: 12, color: kGrey600, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Bouton principal
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              icon: const Icon(Icons.dashboard_outlined, size: 18),
              label: const Text('Accéder au tableau de bord Avia',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            
              onPressed: () async {
                await _viewModel.createEntreprise(    
                    nameEntreprise: nomEntreprise,
                    secteurEntreprise: secteur,
                    villeEntreprise: localisation,

                    tailleEntrprise: tailleEntreprise,

                    logoEntreprise: logoEntreprise,

                    namePDG: nomPdg,
                    firstNamePDG: prenomPdg,

                    emailPDG: email,

                    pwdPDG: pwdPDG,
                    confirPwdPDG: confirPwdPDG,

                    nbServices: nbServices,

                    telPDG: tel,

                    serviceEntreprise: servicesNoms,
                
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TableauBordEntreprise(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Bouton secondaire
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: kGrey600,
                side: const BorderSide(color: kGrey200, width: 0.8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.send_outlined, size: 18),
              label: const Text('Renvoyer l\'email de vérification',
                  style: TextStyle(fontSize: 14)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widgets utilitaires ─────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String stepLabel;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final String nextLabel;
  final IconData nextIcon;

  const _FormCard({
    required this.title,
    required this.subtitle,
    required this.stepLabel,
    required this.child,
    required this.onNext,
    this.onBack,
    this.nextLabel = 'Suivant',
    this.nextIcon = Icons.arrow_forward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGrey200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: kGrey900)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 13, color: kGrey600, height: 1.4)),
          const SizedBox(height: 20),
          child,
          const SizedBox(height: 24),
          // Séparateur
          Container(height: 0.8, color: kGrey200),
          const SizedBox(height: 16),
          Row(
            children: [
              if (onBack != null)
                TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back,
                      size: 16, color: kGrey600),
                  label: const Text('Retour',
                      style:
                          TextStyle(color: kGrey600, fontSize: 14)),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero),
                ),
              const Spacer(),
              Text(stepLabel,
                  style: const TextStyle(
                      fontSize: 12, color: kGrey400)),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onPressed: onNext,
                label: Text(nextLabel),
                icon: Icon(nextIcon, size: 16),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: kGrey600),
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  const _SizeOption({
    required this.label,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kBlueLight : Colors.white,
            border: Border.all(
              color: selected ? kBlue : kGrey200,
              width: selected ? 1.5 : 0.8,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? kBlue : kGrey900)),
              const SizedBox(height: 2),
              Text(desc,
                  style: TextStyle(
                      fontSize: 11,
                      color: selected ? kBlueMid : kGrey600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecapChip extends StatelessWidget {
  final String label;
  final String value;
  const _RecapChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label : ',
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF1a4ab0))),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a4ab0))),
      ],
    );
  }
}

class _RecapRow extends StatelessWidget {
  final String label;
  final String value;
  const _RecapRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: kGrey200, width: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: kGrey600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    color: kGrey900,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}