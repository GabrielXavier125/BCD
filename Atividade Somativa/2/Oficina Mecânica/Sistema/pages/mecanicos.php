<?php
// CRUD de mecânicos

// CREATE / UPDATE
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id           = $_POST['id_mecanico'] ?? '';
    $nome         = trim($_POST['nome'] ?? '');
    $especialidade= trim($_POST['especialidade'] ?? '');

    if ($nome !== '') {
        if ($id) {
            $stmt = $pdo->prepare("UPDATE mecanicos
                                   SET nome=?, especialidade=?
                                   WHERE id_mecanico=?");
            $stmt->execute([$nome, $especialidade, $id]);
        } else {
            $stmt = $pdo->prepare("INSERT INTO mecanicos (nome, especialidade)
                                   VALUES (?, ?)");
            $stmt->execute([$nome, $especialidade]);
        }
    }
    header("Location: index.php?page=mecanicos");
    exit;
}

// DELETE
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $pdo->prepare("DELETE FROM mecanicos WHERE id_mecanico = ?")->execute([$id]);
    header("Location: index.php?page=mecanicos");
    exit;
}

// EDIT
$mecEdicao = null;
if (isset($_GET['edit'])) {
    $id = (int)$_GET['edit'];
    $stmt = $pdo->prepare("SELECT * FROM mecanicos WHERE id_mecanico = ?");
    $stmt->execute([$id]);
    $mecEdicao = $stmt->fetch();
}

// LISTA
$mecanicos = $pdo->query("SELECT * FROM mecanicos ORDER BY nome")->fetchAll();
?>
<div class="section-header">
  <h2>Mecânicos</h2>
</div>

<div class="grid-2">
  <div class="card form-card">
    <h3><?php echo $mecEdicao ? 'Editar Mecânico' : 'Novo Mecânico'; ?></h3>
    <form method="post">
      <input type="hidden" name="id_mecanico" value="<?php echo $mecEdicao['id_mecanico'] ?? ''; ?>">
      <div class="form-group">
        <label>Nome</label>
        <input type="text" name="nome" required
               value="<?php echo htmlspecialchars($mecEdicao['nome'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Especialidade</label>
        <input type="text" name="especialidade"
               value="<?php echo htmlspecialchars($mecEdicao['especialidade'] ?? ''); ?>">
      </div>
      <button type="submit" class="btn primary">
        <?php echo $mecEdicao ? 'Atualizar' : 'Salvar'; ?>
      </button>
      <?php if ($mecEdicao): ?>
        <a href="index.php?page=mecanicos" class="btn secondary">Cancelar</a>
      <?php endif; ?>
    </form>
  </div>

  <div class="card">
    <h3>Lista de Mecânicos</h3>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Especialidade</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($mecanicos as $m): ?>
            <tr>
              <td><?php echo $m['id_mecanico']; ?></td>
              <td><?php echo htmlspecialchars($m['nome']); ?></td>
              <td><?php echo htmlspecialchars($m['especialidade']); ?></td>
              <td>
                <a class="btn secondary" href="index.php?page=mecanicos&edit=<?php echo $m['id_mecanico']; ?>">Editar</a>
                <a class="btn danger" href="index.php?page=mecanicos&delete=<?php echo $m['id_mecanico']; ?>"
                   onclick="return confirm('Deseja realmente excluir este mecânico?');">
                  Excluir
                </a>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>
